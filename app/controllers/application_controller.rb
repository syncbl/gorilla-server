class ApplicationController < ActionController::Base
  before_action :check_headers?, unless: :devise_controller?
  acts_as_token_authentication_handler_for User
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def check_headers?
    if request.format.json? &&
        (request.headers['X-User-Key'].blank? ||
        request.headers['X-User-Token'].blank? ||
        request.headers['X-User-Endpoint'].blank? ||
        (request.headers['X-API-VersionId'] != Rails.application.config.api_version))
      render json: { error: I18n.t('devise.failure.unauthenticated') }, status: :unauthorized
    end

    # TODO: To check license
    #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM

    # TODO: To check endpoint params
    #request.headers['Endpoint-ID']
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
