class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :api_check_headers, if: -> { request.format.json? && Rails.env.production? }
  before_action :api_check_endpoint, if: -> { request.format.json? && !devise_controller? }

  protected

  # TODO: I18n
  def api_check_headers
    unless (request.headers['X-API-Fingerprint'] == Rails.application.config.api_fingerprint) &&
           service_keys.include?(request.headers['X-API-Service'])
      head :upgrade_required
    end
  end

  def api_check_endpoint
    if payload = JsonWebToken.decode(request.headers['X-API-Token'])
      endpoint = Endpoint.find_by(
        key: payload[:key],
        authentication_token: payload[:token]
      )
      if endpoint.nil?
        Endpoint.find_by(key: payload[:key])&.block! ' stolen token '
      else
        bypass_sign_in(endpoint.user) unless user_signed_in?
        current_user.endpoint = endpoint
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :locale])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :locale])
  end

  # TODO: To check license
  #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM
end
