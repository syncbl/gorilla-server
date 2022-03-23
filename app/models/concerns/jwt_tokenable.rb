module JwtTokenable
  extend ActiveSupport::Concern
  require "jwt"

  def token_needs_reset?
    reseted_at.nil? || reseted_at < Time.current - TOKEN_RESET_THRESHOLD
  end

  def reset_token!
    # TODO: Check for reseted database record
    # Login will be successful, but none of the next queries
    regenerate_authentication_token
    JWT.encode(
      {
        scope: self.class.name,
        uuid: id,
        token: authentication_token,
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
end
