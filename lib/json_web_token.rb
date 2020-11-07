class JsonWebToken
  require 'jwt'

  def self.encode(resource)
    if resource.is_a? Endpoint
      exp = Time.current.to_i + 1.month
    elsif resource.is_a? User
      exp = Time.current.to_i + 1.week
    end
    payload = {
      scope: resource.class.name,
      uuid: resource.id,
      token: resource.authentication_token,
      exp: exp
    }
    JWT.encode(payload.to_a.shuffle.to_h, Rails.application.credentials.jwt_secret, 'HS256') if payload
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.jwt_secret, true, { algorithm: 'HS256' })&.
      first&.with_indifferent_access
  rescue JWT::ExpiredSignature, JWT::DecodeError
    false
  end

end
