class DatasetController < ApplicationController
  include ApplicationHelper

  def index
    @datasets = Dataset.joins(:category).order("categories.id, datasets.name").all
  end

  def show
    @dataset = Dataset.where(:slug => params[:slug]).first
  end
end
