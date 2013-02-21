class GeographyController < ApplicationController
  def index
    @geographies = Geography.order("name").all
  end

  def show
    @geography = Geography.where(:slug => params[:slug]).first
    @categories = Category.all
    
  end

end
