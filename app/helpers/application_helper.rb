module ApplicationHelper
  include Pagy::Frontend

  # TODO: Rebuild this part
  def app_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Add dictionary of available services
    [
      app_key(Rails.application.config.syncable.service_path)
    ]
  end

  def anonymous_keys
    # TODO: Add dictionary of available services
    [
      app_key(Rails.application.config.syncable.service_path)
    ]
  end

  # TODO: Authorization token for endpoint
  def generate_token
    unless @endpoint.nil?
      render json: {
        session: {
          token: JsonWebToken.encode(@endpoint)
        }
      }, status: :accepted
    else
      render json: {
        session: {
          token: JsonWebToken.encode(current_user)
        }
      }, status: :ok
    end
  end

  def alert_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def user_is_endpoint?
    current_user.endpoint.present?
  end

  def require_endpoint!
    unless user_is_endpoint?
      head :unauthorized
    end
  end

  def deny_endpoint!
    if user_is_endpoint?
      head :forbidden
    end
  end

end
