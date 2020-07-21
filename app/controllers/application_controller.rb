class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :api_check_headers, if: -> { request.format.json? }

  protected

  def api_check_headers
    if service_keys.include?(request.headers['X-API-Service']) || Rails.env.development?
      if request.headers['X-API-Token']
        payload = JsonWebToken.decode(request.headers['X-API-Token'])
        case payload[:scope]
        when 'Endpoint'
          if endpoint = Endpoint.kept.find_by(id: payload[:uuid], authentication_token: payload[:token])
            bypass_sign_in(endpoint.user) unless user_signed_in?
            current_user.endpoint = endpoint
          else
            Endpoint.find_by(id: payload[:uuid])&.block! reason: "#{payload[:uuid]}|#{payload[:token]}"
          end
        when 'User'
          if user = User.kept.find_by(id: payload[:uuid], authentication_token: payload[:token])
            bypass_sign_in(user) unless user_signed_in?
          end
        end
      end
    elsif anonymous_keys.include?(request.headers['X-API-Service'])
      return true
    else
      head :upgrade_required
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :locale])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :locale])
  end

  # TODO: To check license
  #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM
end
