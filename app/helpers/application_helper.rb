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

  def user_is_endpoint?
    !current_user.endpoint.nil?
  end

  def require_endpoint!
    head :unauthorized unless user_is_endpoint?
  end

  def deny_endpoint!
    head :forbidden if user_is_endpoint?
  end

  def cached_endpoint_user(id, token)
    @cached_endpoint ||= begin
      Rails.cache.fetch(
        "endpoint_#{id}",
        expires_in: 15.minutes
      ) do
        Endpoint.active.includes(:user).find_by(
          id: id,
          authentication_token: token
        )
      end
    end
    @cached_user ||= begin
      Rails.cache.fetch(
        "endpoint_user_#{id}",
        expires_in: MODEL_CACHE_TIMEOUT
      ) do
        @cached_endpoint.user
      end
    end
    return @cached_endpoint, @cached_user
  end

  def cached_user(id, token)
    @cached_user ||= begin
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

end
