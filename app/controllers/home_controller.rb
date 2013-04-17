class HomeController < ApplicationController
  include ApplicationHelper

  def index
  end

  def leaflet_test
    @zip = Geography.where(:name => '60614').first 
    puts @zip
  end

  def interventions_test
    @interventions = InterventionLocation.all

    @points = []
    @interventions.each do |p|
      @points << [p[:name], p[:address], p[:latitude], p[:longitude]]
    end
    # puts @points.inspect
  end

  def map
    if params[:dataset_slug].nil?
      @current_dataset = Dataset.order("name").first
      redirect_to :action => "map", :dataset_slug => @current_dataset.slug
    else
      @current_dataset = Dataset.where("slug = '#{params[:dataset_slug]}'").first
      
      @display_geojson = community_area_geojson(@current_dataset.id)
      @intervention_locations = intervention_locations(@current_dataset.id)
      @categories = Category.all

    end
  end

end
