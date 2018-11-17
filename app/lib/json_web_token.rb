# frozen_string_literal: true

class JsonWebToken
  # secret to encoide and decode token
  HMAC_SECRET = Rails.application.credentials.secret_key_base
  ALGORITHM   = 'HS256'

  # Encode and generate a token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:iat] = Time.zone.now.to_i
    payload[:exp] = exp.to_i

    JWT.encode(payload, HMAC_SECRET, ALGORITHM)
  end

  # Decode and validate the token
  def self.decode(token)
    body = JWT.decode(token, HMAC_SECRET, true, algorithm: ALGORITHM)[0]
    HashWithIndifferentAccess.new(body)
  end
end
