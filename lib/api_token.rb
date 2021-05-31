class ApiToken
  require "jwt"

  class << self
    def encode(resource)
      JWT.encode(
        {
          scope: resource.class.name,
          uuid: resource.id,
          token: resource.authentication_token,
          exp: Time.current.to_i +
               case resource
               when User
                 USER_SESSION_TIME
               when Endpoint
                 ENDPOINT_SESSION_TIME
               end,
        },
        Rails.application.credentials.jwt_secret,
        "HS256"
      )
    end

    def decode(token)
      JWT.decode(
        token,
        Rails.application.credentials.jwt_secret,
        true,
        { algorithm: "HS256" }
      ).first.with_indifferent_access
    rescue JWT::ExpiredSignature, JWT::DecodeError
      false
    end
  end
end
