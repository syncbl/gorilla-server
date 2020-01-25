class ApplicationController < ActionController::Base
  include ApplicationHelper
  require 'date'

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :api_check_version, if: -> { !devise_controller? && request.format.json? }
  before_action :api_check_service, if: -> { !devise_controller? && request.format.json? }
  before_action :api_sign_in_endpoint, if: -> { request.format.json? }

  protected

  def api_check_version
    render_error_json('E_API_VERSION', ' wrong version ', :forbidden) if
      request.headers['X-API-Version'] != Rails.application.config.api_version
  end

  def api_check_service
    render_error_json('E_SERVICE_KEY', ' missing keys ', :forbidden) unless
      service_keys.include?(request.headers['X-API-Service'])
  end

  def api_sign_in_endpoint
    return true if request.headers['X-API-Token'].blank?
    endpoint = Endpoint.find_by(authentication_token: request.headers['X-API-Token'])
    if Time.current > (endpoint.updated_at + Rails.application.config.api_session_limit)
      render_error_json('E_SESSION_EXPIRED', ' session expired ', :unauthorized)
    else
      bypass_sign_in(endpoint.user)
      current_user.endpoint = endpoint
    end
  end

  # TODO: To check license
  #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
