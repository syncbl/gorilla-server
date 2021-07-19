class Api::Token
  require "jwt"

  class << self
    def encode(resource)
      resource.token = JWT.encode(
        {
          scope: resource.class.name,
          uuid: resource.id,
          token: resource.authentication_token,
          exp: Time.current.to_i +
               case resource
               when User
                 USER_SESSION_TIME
               when Endpoint
                 if resource.user.nil?
                   ANONYMOUS_SESSION_TIME
                 else
                   ENDPOINT_SESSION_TIME
                 end
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
      nil
    end
  end
end
