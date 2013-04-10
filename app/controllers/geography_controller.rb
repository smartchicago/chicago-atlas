class GeographyController < ApplicationController
  include ApplicationHelper

  def index
    @geographies = Geography.order("name").all
  end

  def show
    @geography = Geography.where(:slug => params[:slug]).first
    @categories = Category.all
  end

  def showdataset
    @geography = Geography.where(:slug => params[:geo_slug]).first
    @dataset = Dataset.where(:slug => params[:dataset_slug]).first
    @intervention_locations = intervention_locations(@dataset.id)
  end

end
