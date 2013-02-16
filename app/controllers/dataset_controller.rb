class DatasetController < ApplicationController
  
  def index
    @datasets = Dataset.joins(:category).all
  end

  def show
    @dataset = Dataset.where(:slug => params[:slug]).first
  end
end
