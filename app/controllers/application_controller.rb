class ApplicationController < ActionController::Base
  before_action :check_headers, unless: :devise_controller?
  acts_as_token_authentication_handler_for User
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def check_headers
    if request.format.json?
      if request.headers['X-User-Key'].blank? ||
          request.headers['X-User-Token'].blank? ||
          request.headers['X-User-Endpoint'].blank?
        render json: { error: I18n.t(' missing keys ') }, status: :unauthorized
      elsif (request.headers['X-API-Version'] != Rails.application.config.api_version) ||
            (request.headers['X-API-Service'] != Digest::MD5.file('storage/README.md').base64digest)
        render json: {
            error: I18n.t(' wrong version '),
            service: 'storage/README.md'
          }, status: :forbidden
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
