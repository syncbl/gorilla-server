module ApplicationHelper

  def service_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Add dictionary of available services
    [
      service_key(Rails.application.config.service_path)
    ]
  end

  def register_endpoint(params)
    if params.present?
      endpoint = current_user.endpoints.find_by(id: params[:uuid]) ||
                 current_user.endpoints.create(name: params[:name])
      render json: {
        session: {
          token: JsonWebToken.encode(endpoint)
        }
      }
    else
      render json: {
        session: {
          token: JsonWebToken.encode(current_user)
        }
      }
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

  def authenticate_endpoint!
    if current_user.endpoint.nil?
      head :unauthorized 
    end
  end
end
