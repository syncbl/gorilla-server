class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pagy::Backend

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :api_check_headers, if: -> { request.format.json? }
  before_action :set_locale

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  protected

  # TODO: Layout
  def render_403
    respond_to do |format|
      format.html { render "errors/403", layout: "errors", status: :forbidden }
      format.any { head :forbidden }
    end
  end

  def render_404
    respond_to do |format|
      format.html { render "errors/404", layout: "errors", status: :not_found }
      format.any { head :not_found }
    end
  end

  def render_json_error(messages, status:)
    if messages.is_a? Array
      render json: { errors: messages }, status: status
    else
      render json: { error: messages }, status: status
    end
  end

  private

  def api_check_headers
    service = request.headers["X-API-Service"]
    if request.headers["X-API-Token"].present?
      if payload = Api::Token.decode(request.headers["X-API-Token"])
        scope = payload[:scope]
        uuid = payload[:uuid]
        token = payload[:token]
      else
        render_json_error I18n.t("devise.failure.timeout"), status: :unauthorized
      end
    end

    # Idea: add blocked uuid to array in order to avoid multiqueries
    if scope == Endpoint.name && Api::Keys.endpoint.include?(service)
      if endpoint = cached_endpoint(uuid, token)
        # Can't allow to endpoint access all other endpoints and user data
        # sign_in endpoint.user
        if endpoint.token == token
          endpoint.reset_token
        else
          endpoint.touch
        end
      else
        Rails.logger.warn "Blocked request: #{scope} #{uuid}"
        Endpoint.find_by(id: uuid)&.regenerate_authentication_token
        render_json_error I18n.t("devise.failure.blocked"), status: :unauthorized
      end
    elsif scope == User.name && Api::Keys.user.include?(service)
      unless sign_in cached_user(uuid, token)
        Rails.logger.warn "Blocked request: #{scope} #{uuid}"
        render_json_error I18n.t("devise.failure.blocked"), status: :unauthorized
      end
    elsif Api::Keys.anonymous.include?(service)
      true
    elsif service.present?
      head :upgrade_required
    else
      Rails.logger.warn "Forbidden request from #{request.remote_ip}"
      head :forbidden
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[fullname name locale])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[fullname name locale])
  end

  def set_locale
    session[:locale] ||= current_endpoint&.locale ||
                         current_user&.locale ||
                         http_accept_language.compatible_language_from(I18n.available_locales) ||
                         I18n.default_locale.to_s
    I18n.locale = session[:locale]
  end
end
