class DatasetController < ApplicationController
  include ApplicationHelper

  def index
    @datasets = Dataset.joins(:category).order("categories.id, datasets.name").all
  end

  def show
    @dataset = Dataset.where(:slug => params[:slug]).first
  end

  def interventions
    interventionmap = intervention_locations( [params[:north], params[:east], params[:south], params[:west] ])
    respond_to do |format|
      format.json { render :json => interventionmap }
    end
  end
end
