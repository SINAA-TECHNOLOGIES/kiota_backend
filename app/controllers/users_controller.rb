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
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role, :country_id)
  end
end
