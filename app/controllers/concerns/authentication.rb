module Authentication
  def cache_fetch(model, id, token)
    cached_instance = model.fetch(id)
    if ActiveSupport::SecurityUtils.secure_compare(cached_instance&.authentication_token, token) &&
       cached_instance&.not_blocked?
       cached_instance
    else
      raise CanCan::AccessDenied
    end
  end

  def current_user
    current_endpoint&.user || super
  end

  def current_resource
    @current_resource
  end

  def current_endpoint
    current_resource if endpoint_signed_in?
  end

  def sign_in_endpoint(endpoint)
    @current_resource = endpoint
  end

  def endpoint_signed_in?
    @current_resource.is_a? Endpoint
  end

  def reset_token!
    response.set_header('Access-Token', current_resource.reset_token!)
  end

  def authenticate_endpoint!
    raise CanCan::AccessDenied unless endpoint_signed_in?
  end

  def forbid_for_endpoint!
    raise CanCan::AccessDenied if endpoint_signed_in?
  end

  def decode_token(token)
    payload =
      JWT.decode(
        token,
        Rails.application.credentials.jwt_secret,
        true,
        { algorithm: "HS256" },
      ).first.with_indifferent_access
    return payload[:scope], payload[:uuid], payload[:token]
  rescue JWT::ExpiredSignature, JWT::DecodeError
    nil
  end
end
