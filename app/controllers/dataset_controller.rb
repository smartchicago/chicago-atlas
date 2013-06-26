class DatasetController < ApplicationController
  include ApplicationHelper

  def index
    @datasets = Dataset.joins(:category).order("categories.id, datasets.name").all
  end

  def show
    @dataset = Dataset.where(:slug => params[:slug]).first
  end

  def resources
    resources_map = resource_locations( [params[:north], params[:east], params[:south], params[:west] ])
    puts resources_map.inspect

    respond_to do |format|
      format.json { render :json => resources_map }
    end
  end
end
