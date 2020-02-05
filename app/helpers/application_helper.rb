module ApplicationHelper

  def service_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Cache results!
    [
      "#DEV#",
      service_key(Rails.application.config.service_path)
    ]
  end

  def render_error_json(event, error, status)
    render json: {
      version: Rails.application.config.api_version,
      event: event,
      error: I18n.t(error),
    }, status: status
  end

  def respond_with_endpoint_token(endpoint)
    render json: {
      version: Rails.application.config.api_version,
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
end
