class ResourcesController < ApplicationController
  def index
    @resources = Resource.all.paginate(:page => params[:page], :per_page => 16)
  end

  def create
  end

  def show
    @resources = Resource.where(uploader_id: params[:id]).paginate(:page => params[:page], :per_page => 16)
  end
end
