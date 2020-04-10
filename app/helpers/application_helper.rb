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

  # TODO: Lists of MD5 split by scopes. Service = endpoint, desktop = user.
  def sign_in_endpoint(user, params)
    if params[:endpoint].present?
      endpoint = user.endpoints.find_by(id: params[:endpoint][:uuid]) ||
                 user.endpoints.create(name: params[:endpoint][:name])
      render json: {
        session: {
          scope: 'endpoint',
          token: JsonWebToken.encode(endpoint)
        }
      }
    elsif user.company.present?
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
    head :forbidden if current_user.endpoint.nil?
  end

end
