class GeographyController < ApplicationController
  def index
    @geographies = Geography.order("name").all
  end

  def show
    @geography = Geography.where(:slug => params[:slug]).first
    @categories = Category.all
    @datasets = Dataset.joins(:statistics)
      .select("datasets.id, datasets.name, statistics.name as stat_name")
      .where("statistics.geography_id" => @geography.id)
      .group("datasets.id, datasets.name, statistics.name")
      .order("datasets.name, statistics.name")
  end

  def categoryPartial

  end
end
