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
    render_error_json('E_API_VERSION', ' wrong version ', :forbidden) if
      request.headers['X-API-Version'] != Rails.application.config.api_version
  end

  def api_check_service
    render_error_json('E_API_SERVICE', ' missing keys ', :forbidden) unless
      service_keys.include?(request.headers['X-API-Service'])
  end

  def api_sign_in_endpoint
    return true if request.headers['X-API-Token'].blank?
    endpoint = Endpoint.find_by(authentication_token: request.headers['X-API-Token'])
    if Time.current > (endpoint.updated_at + Rails.application.config.api_session_limit)
      render_error_json('E_API_SESSION', ' session expired ', :unauthorized)
    else
      bypass_sign_in(endpoint.user) unless user_signed_in?
      current_user.endpoint = endpoint
    end
  end

  # TODO: To check license
  #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM
end
