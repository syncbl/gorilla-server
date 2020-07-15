module ApplicationHelper

  def service_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Change detect method!
    [
      service_key(Rails.application.config.service_path)
    ]
  end

  def register_endpoint(endpoint_params)
    if endpoint_params.present?
      endpoint = current_user.endpoints.find_by(id: endpoint_params[:uuid]) ||
                 current_user.endpoints.create(name: endpoint_params[:name])
    end

    if endpoint
      render json: {
        session: {
          scope: 'endpoint',
          token: JsonWebToken.encode(endpoint)
        }
      }
    # TODO: Remove non-endpoint authorization
    elsif current_user&.company.present?
      render json: {
        session: {
          scope: 'company'
        }
      }
    else
      render json: {
        session: {
          scope: 'user'
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
