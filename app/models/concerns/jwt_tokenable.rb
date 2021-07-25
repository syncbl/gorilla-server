module JwtTokenable
  extend ActiveSupport::Concern
  require "jwt"

  def reset_token
    regenerate_authentication_token if rand(TOKEN_RANDOM_FACTOR) == 0
    self.token = JWT.encode(
      {
        scope: self.class.name,
        uuid: self.id,
        token: self.authentication_token,
        exp: Time.current.to_i +
             case self
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
end
