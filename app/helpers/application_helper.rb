module ApplicationHelper

  def service_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Change detect method!
    [
      "#DEV#",
      service_key(Rails.application.config.service_path)
    ]
  end

  def respond_with_endpoint_token(endpoint)
    render json: {
      fingerprint: Rails.application.config.api_fingerprint,
      session: {
        endpoint: endpoint.key,
        token: endpoint.authentication_token
      }
    }
  end

  def authenticate_endpoint(user, params)
    endpoint = Endpoint.find_by(user: user, key: params[:endpoint][:key]) ||
               Endpoint.new(user: user) # Can't use param key, because of security issue
    endpoint.name = params[:endpoint][:name]
    if endpoint.new_record?
      endpoint.save
      endpoint.reload
    else
      endpoint.regenerate_authentication_token
    end
    respond_with_endpoint_token(endpoint)
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
