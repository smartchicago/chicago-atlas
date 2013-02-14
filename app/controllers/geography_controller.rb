class GeographyController < ApplicationController
  def index
    @geographies = Geography.all
  end

  def show
    @geography = Geography.where(:slug => params[:id]).first
    @datasets = Dataset.joins(:statistics)
      .select("datasets.name")
      .where("statistics.geography_id" => @geography.id)
      .group("datasets.name")
  end
end
