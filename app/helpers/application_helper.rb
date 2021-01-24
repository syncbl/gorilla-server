module ApplicationHelper
  include Pagy::Frontend

  # TODO: Rebuild this part
  def app_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Add dictionary of available services
    @_service_keys ||= Set[app_key("files/hqdefault.jpg")]
    @_service_keys << "@SERVICE@" if Rails.env.development?
  end

  def anonymous_keys
    # TODO: Add dictionary of available services
    @_anonymous_keys ||= Set[app_key("files/hqdefault.jpg")]
    @_anonymous_keys << "@@" if Rails.env.development?
  end

  def session_json(model)
    { session: { token: JsonWebToken.encode(model) } }
  end

  def alert_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info",
    }[
      flash_type.to_sym
    ] || flash_type.to_s
  end

  def authenticate_endpoint!
    render status: :unauthorized if current_endpoint.nil? || user_signed_in?
  end

  def deny_endpoint!
    render status: :forbidden unless current_endpoint.nil?
  end

  def deny_html
    render status: :method_not_allowed unless request.format.json?
  end

  def cache_fetch(model, id, token)
    Rails.cache.fetch(
      "#{model.name}_#{id}",
      expires_in: MODEL_CACHE_TIMEOUT,
    ) do
      instance = model.find_by(
        id: id,
        authentication_token: token,
        blocked_at: nil,
      )
    end
  end

  def cached_endpoint(id, token)
    @_cached_endpoint ||= cache_fetch(Endpoint, id, token)
  end

  def cached_user(id, token)
    @_cached_user ||= cache_fetch(User, id, token)
  end

  def current_endpoint
    @_cached_endpoint
  end

  def sign_in_endpoint(endpoint)
    endpoint.reset_token
    @_cached_endpoint ||= endpoint
  end
end
