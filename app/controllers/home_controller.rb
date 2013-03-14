class HomeController < ApplicationController
  include ApplicationHelper

  def index
  end

  def leaflet_test
    @community_area = Geography.where(:name => 'Loop').first 
  end

  def map
    if params[:dataset_id].nil? or params[:year].nil?
      @current_dataset = Dataset.order("name").first
      redirect_to :action => "map", :dataset_id => @current_dataset.id, :year => @current_dataset.end_year
    else
      @current_dataset = Dataset.find(params[:dataset_id])

      # when toggling between datasets, year ranges are inconsistent so we need to check for them
      if @current_dataset.start_year > params[:year].to_i
        redirect_to :action => "map", :dataset_id => @current_dataset.id, :year => @current_dataset.start_year
      elsif @current_dataset.end_year < params[:year].to_i
        redirect_to :action => "map", :dataset_id => @current_dataset.id, :year => @current_dataset.end_year
      end
      
      @display_geojson = community_area_geojson(params[:dataset_id], params[:year])
      @categories = Category.all

    end
  end

end
