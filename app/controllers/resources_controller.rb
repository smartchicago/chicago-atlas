class ResourcesController < ApplicationController
  def index
    @resources = Resource.all
  end

  def create
  end

  def show
    @resources = Resource.where(uploader_id: params[:id])
  end
end
