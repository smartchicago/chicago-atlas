module Api
  module V1
    class IndicatorsController < ApiController
      def index
        @resources = Resource.all
        render json: @resources
      end
    end
  end
end
