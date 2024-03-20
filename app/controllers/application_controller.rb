class ApplicationController < ActionController::API
  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: "Access Denied: #{exception.message}" }, status: :forbidden
  end

  def authenticate!
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
      Rails.logger.info "Authenticated User Role: #{@current_user.role}"
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def current_user
    # Your current_user implementation
    Rails.logger.info "Current User: #{@current_user.inspect}"
    @current_user
  end
end
