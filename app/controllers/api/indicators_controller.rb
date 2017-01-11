module API
  class IndicatorsController < ApiController
    before_action :load_resource

    def index
      render json: @resources
    end

    private
      def load_resource
        @resources = Resources.all
      end
  end
end
