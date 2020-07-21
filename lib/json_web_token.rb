class JsonWebToken
  require 'jwt'

  def self.encode(resource)
    if resource.is_a? Endpoint
      exp = Time.current.to_i + Rails.application.config.endpoint_token_expiration_time.to_i
    elsif resource.is_a? User
      exp = Time.current.to_i + Rails.application.config.user_token_expiration_time.to_i
    end
    payload = {
      scope: resource.class.name,
      uuid: resource.id,
      token: resource.authentication_token,
      exp: exp
    }
    # TODO: Generate key in order to send it after login
    JWT.encode(payload.to_a.shuffle.to_h, Rails.application.credentials.secret_key_base, 'HS256') if payload
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })&.
      first&.with_indifferent_access
  rescue JWT::ExpiredSignature, JWT::DecodeError
    false
  end

end
