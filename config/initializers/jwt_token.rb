require 'jwt'

class JwtToken
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload)
    encoded_token = JWT.encode(payload, SECRET_KEY)
    Rails.logger.info("JWT Token encoded: #{encoded_token}")
    encoded_token
  end

  def self.decode(token)
    Rails.logger.info("JWT Token to decode: #{token}")
    decoded_token = JWT.decode(token, SECRET_KEY)[0]
    Rails.logger.info("JWT Token decoded: #{decoded_token}")
    HashWithIndifferentAccess.new(decoded_token)
  rescue JWT::DecodeError => e
    Rails.logger.error("JWT Decode Error: #{e.message}")
    nil
  end
end
