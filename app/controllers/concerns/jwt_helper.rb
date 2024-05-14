module JwtHelper
  require 'jwt'

  # SECRET_KEY = Rails.application.secrets.secret_key_base
  SECRET_KEY = ENV.fetch('SECRET_KEY')

  def encode_token(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    nil
  end
end
