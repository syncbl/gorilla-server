class JsonWebToken
  require 'jwt'

  def self.encode(resource)
    payload = { key: resource.key, token: resource.authentication_token, issued: Time.current.to_i }
    JWT.encode(payload.to_a.shuffle.to_h, Rails.application.credentials.hmac_secret_key)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.hmac_secret_key)
  rescue JWT::ExpiredSignature, JWT::DecodeError
    false
  end

  def self.decode_to_payload(token)
    payload = decode(token).first.with_indifferent_access
  end
end
