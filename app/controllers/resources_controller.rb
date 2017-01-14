class ResourcesController < ApplicationController
  def index
    @resources = Resource.all
  end

  def create

  end
end
