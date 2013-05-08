class HomeController < ApplicationController
  include ApplicationHelper

  def index
  end

  def leaflet_test
    @zip = Geography.where(:name => '60614').first 
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
      #@current_dataset = Dataset.order("name").first
      #redirect_to :action => "map", :dataset_slug => @current_dataset.slug
      redirect_to :action => "map", :dataset_slug => "birth_rate"
    else
      @current_dataset = Dataset.where("slug = '#{params[:dataset_slug]}'").first
      
      @display_geojson = geography_geojson(@current_dataset.id)
      @categories = Category.select('categories.id, categories.name, categories.description')
                            .joins('INNER JOIN datasets ON datasets.category_id = categories.id')
                            .group('categories.id, categories.name, categories.description')
                            .having('count(datasets.id) > 0')
                            .order("categories.name")

    end
  end

end
