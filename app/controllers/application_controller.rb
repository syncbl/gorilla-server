class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pagy::Backend

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :api_check_headers, if: -> { request.format.json? }

  protected

  def api_check_headers
    reset_session
    if service_keys.include?(request.headers['X-API-Service']) ||
         Rails.env.development?
      if request.headers['X-API-Token']
        unless payload = JsonWebToken.decode(request.headers['X-API-Token'])
          return true
        end
        case payload[:scope]
        when Endpoint.name
          if endpoint =
               Endpoint.active.find_by(
                 id: payload[:uuid],
                 authentication_token: payload[:token]
               )
            bypass_sign_in(endpoint.user)
            current_user.endpoint = endpoint
            # TODO: Store request.remote_ip
          else
            puts "!!!!! BLOCK !!!!! #{payload[:uuid]}|#{payload[:token]}"
            # TODO: Endpoint.find_by(id: payload[:uuid])&.block! reason: "#{payload[:uuid]}|#{payload[:token]}"
          end
        when User.name
          if user =
               User.active.find_by(
                 id: payload[:uuid],
                 authentication_token: payload[:token]
               )
            bypass_sign_in(user)
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
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name locale])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name locale])
  end

  # TODO: To check license
  #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM
end
