module Api
  module V1
    class PartnersController < ApiController
      def index
        render json: Partner.all
      end
    end
  end
end
