module Api
  module V1
    class PartnersController < ApiController
      def index
        render json: Partner.all
      end

      def create
        partner = Partner.new(partner_params)
        if partner.save
          render json: status: 200
        else
          render json: status: 500
        end
      end

      def update
        partner = Partner.find(params[:id])
        if partner.update(partner_params)
          render json: status: 200
        else
          render json: status: 500
        end
      end

      def destroy
        partner = Partner.find(params[:id])
        if partner.delete
          render json: status: 200
        else
          render json: status: 500
        end
      end

      private

      def partner_params
        params.require(:partner).permit()
      end
    end
  end
end
