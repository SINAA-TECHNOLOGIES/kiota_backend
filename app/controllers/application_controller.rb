class ApplicationController < ActionController::API
  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: "Access Denied: #{exception.message}" }, status: :forbidden
  end

  def authenticate!
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
      begin
        @decoded = JsonWebToken.decode(token)
        @current_user = User.find(@decoded[:user_id])
        Rails.logger.info "Authenticated User Role: #{@current_user.role}"
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    else
      render json: { errors: 'Authorization header missing' }, status: :unauthorized
    end
  end

  def current_user
    Rails.logger.info "Current User: #{@current_user.inspect}"
    @current_user
  end
end
