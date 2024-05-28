# class ApplicationController < ActionController::API
#   rescue_from CanCan::AccessDenied do |exception|
#     render json: { error: "Access Denied: #{exception.message}" }, status: :forbidden
#   end

#   def authenticate!
#     header = request.headers['Authorization']
#     header = header.split(' ').last if header
#     begin
#       @decoded = JsonWebToken.decode(header)
#       @current_user = User.find(@decoded[:user_id])
#       Rails.logger.info "Authenticated User Role: #{@current_user.role}"
#     rescue ActiveRecord::RecordNotFound => e
#       render json: { errors: e.message }, status: :unauthorized
#     rescue JWT::DecodeError => e
#       render json: { errors: e.message }, status: :unauthorized
#     end
#   end

#   def current_user
#     # Your current_user implementation
#     Rails.logger.info "Current User: #{@current_user.inspect}"
#     @current_user
#   end
# end

class ApplicationController < ActionController::API
  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: "Access Denied: #{exception.message}" }, status: :forbidden
  end

  before_action :authenticate!

  def authenticate!
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
      begin
        @decoded = JsonWebToken.decode(token)
        Rails.logger.info "Decoded Token: #{@decoded.inspect}"
        @current_user = User.find(@decoded[:user_id])
        Rails.logger.info "Authenticated User: #{@current_user.inspect}"
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error "User not found: #{e.message}"
        render json: { errors: "User not found: #{e.message}" }, status: :unauthorized
      rescue JWT::DecodeError => e
        Rails.logger.error "Invalid token: #{e.message}"
        render json: { errors: "Invalid token: #{e.message}" }, status: :unauthorized
      end
    else
      Rails.logger.error "Authorization header missing"
      render json: { errors: 'Authorization header missing' }, status: :unauthorized
    end
  end

  def current_user
    Rails.logger.info "Current User: #{@current_user.inspect}"
    @current_user
  end
end

