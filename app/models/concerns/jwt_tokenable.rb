module JwtTokenable
  extend ActiveSupport::Concern
  require "jwt"

  def reset_token
    if reseted_at.nil? || (Time.current - reseted_at > TOKEN_RESET_PERIOD)
      regenerate_authentication_token
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
    else
      ""
    end
  end

  def self.included(base)
    base.class_eval {
      before_save :update_reseted_at, if: :authentication_token_changed?

      private

      def update_reseted_at
        self.reseted_at = Time.current
      end
    }
  end
end
