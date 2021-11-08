module Api::Token
  def decode_token(token)
    payload =
      JWT
        .decode(
          token,
          Rails.application.credentials.jwt_secret,
          true,
          { algorithm: "HS256" },
        )
        .first
        .with_indifferent_access
    return payload[:scope], payload[:uuid], payload[:token]
  rescue JWT::ExpiredSignature, JWT::DecodeError
    nil
  end
end
