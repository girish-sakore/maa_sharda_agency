module JwtHelper
  require 'jwt'

  SECRET_KEY = "548120c74d3d3d6024b76021553f6131581c056caad046b137364cd26701aa9395dad5a770495a70976d3bcf7395c56c61a4ee9e728348554483050b3c4a1790"
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
