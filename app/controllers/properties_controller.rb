class PropertiesController < ApplicationController
  def index 
    @properties = Property.all
    render json: @properties
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
    @property = Property.find(params[:id])
    authorize! :update, render json: @property
  end

  def destroy
  end
end
