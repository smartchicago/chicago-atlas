module Api
  module V1
    class TopicsController < ApiController
      api :GET, '/topics', 'Fetch category, subcategory, indicators list'
      formats ['json']
      description <<-EOS
        == Fetch category, subcategory, indicators
      EOS
      def index
        render json: CategoryGroup.all
      end

      api :GET, '/topic/:year/:indicator_slug', 'Fetch detailed data of topic'
      param :year, String, :desc => 'year', :required => true
      param :indicator_id, String, :desc => 'indicator id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year
        response data has detailed data for indicator and year
      EOS
      def show
        year = params[:year]
        slug = params[:indicator_id]
        @data = Resource.where("year_from <= ? AND year_to >= ?", year, year).where(indicator_id: slug)
        render json: @data
      end

      api :GET, '/topic/:indicator_slug', 'Fetch detailed data of topic for trend'
      param :indicator_id, String, :desc => 'indicator id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior
        response data has detailed data for indicator(for trend all year data)
      EOS
      def trend
        slug  = params[:indicator_id]
        @data = Resource.where(indicator_id: slug)
        render json: @data
      end
    end
  end
end
