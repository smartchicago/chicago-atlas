class HomeController < ApplicationController
  include ApplicationHelper

  def index
  end

  def leaflet_test
    @community_area = Geography.where(:name => 'Loop').first 
  end

  def map
    if params[:dataset_id].nil? or params[:year].nil?
        redirect_to :action => "map", :dataset_id => Dataset.order("name").first.id, :year => 2009
    else
        @display_geojson = community_area_geojson(params[:dataset_id], params[:year])
        @categories = Category.all

        @current_dataset = Dataset.find(params[:dataset_id])
    end
  end

end
