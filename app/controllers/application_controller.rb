class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for User,
    if: ->(controller) { controller.user_token_authenticable? }

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def user_token_authenticable?
    return false unless request.format.json?
    return false if request.headers['X-User-Email'].blank?
    return false if request.headers['X-User-Token'].blank?
    #return false if request.headers['X-User-Endpoint'].blank?

    # TODO: To check license
    #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM

    # TODO: To check endpoint params
    #request.headers['Endpoint-ID']

    true
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
