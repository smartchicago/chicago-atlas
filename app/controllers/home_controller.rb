class HomeController < ApplicationController

  def index
  end

  def leaflet_test
    @community_area = Geography.where(:name => 'Loop').first 
  end

end
