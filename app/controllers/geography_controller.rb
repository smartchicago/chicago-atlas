class GeographyController < ApplicationController
  def index
    @geographies = Geography.order("name").all
  end

  def show
    @geography = Geography.where(:slug => params[:slug]).first
    @datasets = Dataset.joins(:statistics)
      .select("datasets.id, datasets.name")
      .where("statistics.geography_id" => @geography.id)
      .group("datasets.id, datasets.name")
  end
end
