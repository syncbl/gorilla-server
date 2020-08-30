module ApplicationHelper
  include Pagy::Frontend

  # TODO: Rebuild this part
  def app_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Add dictionary of available services
    [
      app_key(Rails.application.config.service_path)
    ]
  end

  def anonymous_keys
    # TODO: Add dictionary of available services
    [
      app_key(Rails.application.config.service_path)
    ]
  end

  def generate_token(params = nil)
    if params
      endpoint = current_user.endpoints.find_by(id: params[:id]) ||
                 current_user.endpoints.new(name: params[:name])
      if endpoint.new_record?
        status = :created
        # TODO: Touch
        endpoint.save!
      else
        status = :accepted
      end
      render json: {
        session: {
          token: JsonWebToken.encode(endpoint)
        }
      }, status: status
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
