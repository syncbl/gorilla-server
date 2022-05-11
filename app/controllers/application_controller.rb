class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pagy::Backend
  include Pundit::Authorization
  include Authentication

  before_action :skip_session, if: -> { request.format.json? }
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :api_check_headers, if: -> { request.format.json? }
  before_action :set_locale
  after_action :authenticate_with_token!, if: -> {
                                            request.format.json? &&
                                              current_resource&.token_needs_reset?
                                          }

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Pundit::NotAuthorizedError, with: :render_403

  private

  def api_check_headers
    return true if Rails.env.test?

    service = request.headers["X-API-Service"]
    if request.headers["Authorization"].present?
      scope, uuid, token = decode_token(request.headers["Authorization"])
      unless uuid
        render_json_error I18n.t("devise.failure.timeout"),
                          status: :unauthorized
      end
    end

    if Api::Keys.new.find(service)
      case scope
      when "Endpoint"
        unless sign_in_endpoint cached_endpoint(uuid, token)
          render_json_error I18n.t("devise.failure.unauthenticated"),
                            status: :unauthorized
        end
        if current_endpoint.remote_ip != request.remote_ip
          Rails.logger.warn "Endpoint #{current_endpoint.id} IP changed " \
                            "from #{current_endpoint.remote_ip} to #{request.remote_ip}"
          current_endpoint.update(remote_ip: request.remote_ip,
                                  reseted_at: nil)
        end
      when "User"
        unless sign_in cached_user(uuid, token)
          render_json_error I18n.t("devise.failure.unauthenticated"),
                            status: :unauthorized
        end
      end
    elsif service.present?
      head :upgrade_required
    else
      Rails.logger.warn "Forbidden request from #{request.remote_ip}"
      # TODO: render_403 or show warning that account can or will be blocked
      head :forbidden
    end
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
      # TODO: Request locale (but errors must be in user's locale)
      current_resource&.locale ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale.to_s
    I18n.locale = session[:locale]
  end

  def skip_session
    request.session_options[:drop] = true
  end
end
