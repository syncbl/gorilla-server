class ApplicationController < ActionController::Base
  include ApplicationHelper
  require 'date'

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  if Rails.env.production?
    before_action :api_check_version, if: -> { request.format.json? && !devise_controller? }
    before_action :api_check_service, if: -> { request.format.json? && !devise_controller? }
  end
  before_action :api_sign_in_endpoint, if: -> { request.format.json? }

  protected

  # TODO: I18n
  def api_check_version
    render_error_json('E_API_WRONG_VERSION', ' wrong version ', :forbidden) if
      request.headers['X-API-Version'] != Rails.application.config.api_version
  end

  def api_check_service
    render_error_json('E_API_UNSUPPORTED_SERVICE', ' missing keys ', :forbidden) unless
      service_keys.include?(request.headers['X-API-Service'])
  end

  # TODO: Change and resend token on random query
  def api_sign_in_endpoint
    return true if request.headers['X-API-Token'].blank?
    endpoint = Endpoint.find_by(authentication_token: request.headers['X-API-Token'])
    if endpoint && endpoint.updated_at > Time.current - Rails.application.config.api_session_limit
      bypass_sign_in(endpoint.user)
      current_user.endpoint = endpoint if user_signed_in?
    else
      render_error_json('E_API_SESSION_EXPIRED', ' session expired ', :unauthorized)
    end
  end

  # TODO: To check license
  #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM
end
