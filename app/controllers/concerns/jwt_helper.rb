module JwtHelper
  require 'jwt'

  SECRET_KEY = Rails.application.credentials.secret_key_base
  # SECRET_KEY = ENV.fetch('SECRET_KEY')

  def encode_token(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    Rails.logger.warn("token verification error - #{e}")
    nil
  rescue JWT::DecodeError => e
    Rails.logger.warn("token decode error - #{e}")
    nil
  end
end
