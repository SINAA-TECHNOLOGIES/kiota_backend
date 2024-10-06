# class JsonWebToken
#   class << self
#     def encode(payload, exp = 24.hours.from_now)
#       payload[:exp] = exp.to_i
#       JWT.encode(payload, Rails.application.secrets.secret_key_base)
#     end

#     def decode(token)
#       decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
#       HashWithIndifferentAccess.new decoded
#     rescue JWT::ExpiredSignature, JWT::DecodeError
#       nil
#     end
#   end
# end
class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      secret_key = Rails.application.secrets.secret_key_base
      Rails.logger.info "Encoding with SECRET_KEY_BASE: #{secret_key}"
      token = JWT.encode(payload, secret_key)
      Rails.logger.info "Generated Token: #{token}"
      token
    end

    def decode(token)
      Rails.logger.info "Decoding Token: #{token}"
      secret_key = Rails.application.secrets.secret_key_base
      Rails.logger.info "Using SECRET_KEY_BASE: #{secret_key}"
      begin
        decoded = JWT.decode(token, secret_key)[0]
        Rails.logger.info "Decoded JWT Body: #{decoded.inspect}"
        HashWithIndifferentAccess.new(decoded)
      rescue JWT::ExpiredSignature
        Rails.logger.error "JWT Decode Error: Token has expired"
        nil
      rescue JWT::VerificationError
        Rails.logger.error "JWT Decode Error: Verification failed"
        nil
      rescue JWT::DecodeError
        Rails.logger.error "JWT Decode Error: Decode error"
        nil
      end
    end
    private

    def jwt_secret_key
      ENV['JWT_SECRET_KEY'] || Rails.application.secrets.secret_key_base
    end
  end
end

