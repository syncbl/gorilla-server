class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :api_check_fingerprint, if: -> { request.format.json? }
  before_action :api_check_service, if: -> { request.format.json? && Rails.env.production? }
  before_action :api_check_endpoint, if: -> { request.format.json? && !devise_controller? }

  protected

  # TODO: I18n
  def api_check_fingerprint
    if request.headers['X-API-Fingerprint'] != Rails.application.config.api_fingerprint
      head :upgrade_required
    end
  end

  def api_check_service
    unless service_keys.include?(request.headers['X-API-Service'])
      head :upgrade_required
    end
  end

  def api_check_endpoint
    # TODO: JWT? Just to include specific endpoint info
    current_user.endpoint_key = request.headers['X-API-Endpoint']
    current_user.endpoint_token = request.headers['X-API-Token']
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :locale])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :locale])
  end

  # TODO: To check license
  #User.find_by(email: request.headers['X-User-Email']).endpoints.size <= MAXIMUM
end
