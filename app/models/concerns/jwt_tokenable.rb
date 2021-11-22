module JwtTokenable
  extend ActiveSupport::Concern
  require "jwt"

  def reset_token
    return "" unless token_needs_reset?
    regenerate_authentication_token
    self.token =
      JWT.encode(
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
        }.to_a.shuffle.to_h,
        Rails.application.credentials.jwt_secret,
        "HS256",
      )
  end

  def self.included(base)
    base.class_eval do
      has_event :reset, skip_scopes: true

      validate :update_reseted_at, if: :authentication_token_changed?

      private

      def update_reseted_at
        self.reseted_at = Time.current
      end
    end
  end

  private

  def token_needs_reset?
    token_reset_period = case self
      when User
        USER_SESSION_TIME / 2
      when Endpoint
        ENDPOINT_SESSION_TIME / 2
      end
    reseted_at.nil? || (Time.current - reseted_at > token_reset_period)
  end
end
