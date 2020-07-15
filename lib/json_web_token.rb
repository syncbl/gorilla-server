class JsonWebToken
  require 'jwt'

  def self.encode(resource)
    if resource.is_a? Endpoint
      payload = {
        uuid: resource.id,
        token: resource.authentication_token,
        exp: Time.current.to_i + Rails.application.config.token_expiration_time.to_i
      }
    end
    JWT.encode(payload.to_a.shuffle.to_h, Rails.application.credentials.secret_key_base, 'HS256') if payload
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })&.
      first&.with_indifferent_access
  rescue JWT::ExpiredSignature, JWT::DecodeError
    false
  end

end
