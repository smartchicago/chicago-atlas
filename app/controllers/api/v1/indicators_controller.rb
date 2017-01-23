module API
  class Api::IndicatorsController < ApiController
    def index
      @resources = Resource.all
      render json: @resources
    end
  end
end
