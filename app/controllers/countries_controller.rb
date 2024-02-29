class CountriesController < ApplicationController
  def index 
    @countries = Country.all
    render json: @countries
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
  end

  def destroy
  end
end
