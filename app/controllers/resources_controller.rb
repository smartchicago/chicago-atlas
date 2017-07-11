class ResourcesController < ApplicationController
  before_action :authenticate_user!
  def index
    @resources = Resource.all.paginate(:page => params[:page], :per_page => 16)
  end

  def create
  end

  def show
    @uploader = Uploader.find_by_id(params[:id])
    @resources = Resource.where(uploader_id: params[:id]).paginate(:page => params[:page], :per_page => 16)
  end
end
