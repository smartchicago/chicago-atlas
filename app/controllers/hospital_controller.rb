class HospitalController < ApplicationController
  def index
  	@hospitals = Provider.where("primary_type = 'Hospital'")
  end

  def show
  	@hospital = Provider.where(:slug => params[:slug]).first || not_found
  end
end
