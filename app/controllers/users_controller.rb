class UsersController < ApplicationController
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
    @user = User.new(user_params)
    if @user.save
      render json: { user: @user, message: 'User was successfully created' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password_digest, :role, :country_id)
  end
end
