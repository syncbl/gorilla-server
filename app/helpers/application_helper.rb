module ApplicationHelper
  include Pagy::Frontend

  # TODO: Rebuild this part
  def app_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Add dictionary of available services
    [app_key('files/hqdefault.jpg')]
  end

  def anonymous_keys
    # TODO: Add dictionary of available services
    [app_key('files/hqdefault.jpg')]
  end

  # TODO: Authorization token for endpoint
  def generate_token
    unless @endpoint.nil?
      render json: { session: { token: JsonWebToken.encode(@endpoint) } },
             status: :accepted
    else
      render json: { session: { token: JsonWebToken.encode(current_user) } },
             status: :ok
    end
  end

  def alert_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }[
      flash_type.to_sym
    ] || flash_type.to_s
  end

  def require_endpoint!
    head :unauthorized if current_endpoint.nil?
  end

  def deny_endpoint!
    head :forbidden unless current_endpoint.nil?
  end

  def cached_endpoint(id, token)
    @_cached_endpoint ||= begin
      Rails.cache.fetch(
        "#{Endpoint.name}_#{id}",
        expires_in: MODEL_CACHE_TIMEOUT
      ) do
        Endpoint.active.find_by(
          id: id,
          authentication_token: token
        )
      end
    end
  end

  def cached_user(id, token)
    @_cached_user ||= begin
      Rails.cache.fetch(
        "user_#{id}",
        expires_in: MODEL_CACHE_TIMEOUT
      ) do
        User.active.find_by(
          id: id,
          authentication_token: token
        )
      end
    end
  end

  def current_endpoint
    @_current_endpoint ||= session[:current_endpoint_id]
    unless @_current_endpoint.nil?
      Rails.cache.fetch(
        "#{Endpoint.name}_#{@_current_endpoint}",
        expires_in: MODEL_CACHE_TIMEOUT
      ) do
        Endpoint.active.with_user.find(@_current_endpoint)
      end
    end
  end

  def sign_in_endpoint(endpoint)
    session[:current_endpoint_id] = endpoint&.id
  end

end
