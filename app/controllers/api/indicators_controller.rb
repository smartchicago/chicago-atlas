module API
  class Api::IndicatorsController < ApiController
    before_action :load_resource

    def indicator
      render json: @resources
    end

    private
      def load_resource
        @resources = Resource.all
      end
  end
end
