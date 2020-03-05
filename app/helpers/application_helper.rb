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
  def authenticate_endpoint(user, params)
    if params[:endpoint].present?
      endpoint = Endpoint.find_by(user: user, key: params[:endpoint][:key]) ||
                 Endpoint.new(user: user)
      endpoint.name = params[:endpoint][:name]
      if endpoint.new_record?
        endpoint.save
        endpoint.reload
      else
        endpoint.regenerate_authentication_token
      end
      render json: {
        session: {
          scope: 'endpoint',
          endpoint: endpoint.key,
          token: endpoint.authentication_token
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
end
