class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_action :check_headers
  acts_as_token_authentication_handler_for User
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def check_headers
    if Rails.env.production? && request.format.json?
      if (request.headers['X-API-Version'] != Rails.application.config.api_version)
        render json: {
          version: Rails.application.config.api_version,
          event: 'E_API_VERSION',
          error: I18n.t(' wrong version ')
        }, status: :forbidden
      elsif (request.headers['X-API-Service'] != service_key(Rails.application.config.service_path))
        # TODO: Check this from allowed list including
        render json: {
          version: Rails.application.config.api_version,
          event: 'E_FILE_VERSION',
          error: I18n.t(' wrong requester '),
          url: Rails.application.config.service_path
        }, status: :forbidden
      elsif !devise_controller? && (
              request.headers['X-API-Key'].blank? ||
              request.headers['X-API-Token'].blank? ||
              request.headers['X-API-Endpoint'].blank?
            )
        render json: {
          version: Rails.application.config.api_version,
          event: 'E_SESSION_KEYS',
          error: I18n.t(' missing keys ')
        }, status: :unauthorized
      end
    end

    # TODO: To check license
    #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
