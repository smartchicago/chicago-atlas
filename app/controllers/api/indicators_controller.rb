module API
  class IndicatorsController < ApiController
    before_action :load_resource

    def index
      
    end

    private
      def load_resource
        @indicators = Indicators.all

      end
  end
end
