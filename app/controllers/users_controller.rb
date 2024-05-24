# class UsersController < ApplicationController
#   def index
#     @users = User.includes(:country).all
#     render json: @users
 
#   end

#   def show
#     @user = User.find(params[:id])
#   end

#   def new
#     @user = User.new
#   end

#   def create
#     puts "Received params: #{params.inspect}"
#     @user = User.new(user_params)
#     if @user.save
#       render json: { user: @user, message: 'User was successfully created' }, status: :created
#     else
#       render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
#     end
#   end

#   private

#   def user_params
#     params.require(:user).permit(:name, :email, :password, :role, :country_id)
#   end
# end


class UsersController < ApplicationController
  before_action :authenticate!
  def index
    @users = User.includes(:country).all
    render json: @users
 
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    puts "Received params: #{params.inspect}"
    authorize! :create, User
    if params[:password].present?
      params[:user][:password] = params[:password]
    end
    @user = User.new(user_params) 
    # Further restrictions on who can create which roles
    puts "can create user as manager: #{can? :create, User.new(country_id: user_params[:country_id])}"
    # unless can?(:assign_role, user_params[:role])
    #   return render json: { error: "You are not authorized to create users with this role" }, status: :forbidden
    # end

    unless current_user.role == 'super_user' || (current_user.role == 'manager' && current_user.country_id == @user.country_id)
      return render json: { error: "You are not authorized to create users for other countries" }, status: :forbidden
    end
  

    unless current_ability.can_assign_role?(current_user, @user.role)
      render json: { error: "You are not authorized to assign this role" }, status: :forbidden
      return
    end
    @user = User.new(user_params)
    if @user.save
      render json: { user: @user, message: 'User was successfully created' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role, :country_id)
  end
end
