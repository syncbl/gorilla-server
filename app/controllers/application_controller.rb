class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pagy::Backend
  include Authentication

  before_action :skip_session, if: -> { request.format.json? }
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :api_check_headers, if: -> { request.format.json? }
  before_action :test_helper, if: -> { Rails.env.test? }
  before_action :set_locale
  after_action :reset_token!, if: -> {
                                request.format.json? &&
                                  current_resource&.token_needs_reset?
                              }
  check_authorization unless: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from CanCan::AccessDenied, with: :render_403
  rescue_from ActionController::ParameterMissing, with: :render_400

  helper_method :current_endpoint, :current_resource

  private

  # TODO: Save session in database, store only session id in token
  def api_check_headers
    return true if Rails.env.test?

    service = request.headers["X-API-Service"]
    if request.headers["Authorization"].present?
      scope, id, token = decode_token(request.headers["Authorization"])
      unless id
        render_json_error I18n.t("devise.failure.timeout"),
                          status: :unauthorized
      end
    end

    if Api::Keys.new.find(service)
      case scope
      when "Endpoint"
        raise CanCan::AccessDenied unless sign_in_endpoint cache_fetch(Endpoint, id, token)

        if current_endpoint.remote_ip != request.remote_ip
          Rails.logger.warn "Endpoint #{current_endpoint.id} IP changed " \
                            "from #{current_endpoint.remote_ip} to #{request.remote_ip}"
          current_endpoint.update(remote_ip: request.remote_ip,
                                  reseted_at: nil)
        end
      when "User"
        raise CanCan::AccessDenied unless sign_in cache_fetch(User, id, token)
      end
    elsif service.present?
      head :upgrade_required
    else
      Rails.logger.warn "Forbidden request from #{request.remote_ip}"
      raise CanCan::AccessDenied
    end
  end

  def test_helper
    sign_in_endpoint Endpoint.find(params[:current_endpoint]) if params[:current_endpoint].present?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[fullname name locale],
    )
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[fullname name locale],
    )
  end

  def set_locale
    session[:locale] ||=
      current_resource&.locale ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale.to_s
    I18n.locale = session[:locale]
  end

  def skip_session
    request.session_options[:drop] = true
  end
end
