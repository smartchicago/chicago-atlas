class HomeController < ApplicationController
  include ApplicationHelper

  def index
  end

  def leaflet_test
    @community_area = Geography.where(:name => 'Loop').first 
  end

  def leaflet_community_areas
    if params[:dataset_id].nil? or params[:year].nil?
        redirect_to :action => "leaflet_community_areas", :dataset_id => Dataset.first.id, :year => 2009
    else
        @display_geojson = community_area_geojson(params[:dataset_id], params[:year])
        @datasets = Dataset.all
    end
  end

end
