class HomeController < ApplicationController

  def index
    @geographies = Geography.order("name").all
  end

  def about
  end

end
