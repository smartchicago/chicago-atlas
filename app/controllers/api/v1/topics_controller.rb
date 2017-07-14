module Api
  module V1
    class TopicsController < ApiController
      api :GET, '/topics', 'Fetch category, subcategory, indicators list'
      formats ['json']
      description <<-EOS
        == Fetch category, subcategory, indicators from db in order to get the full list of indicators.
      EOS

      def index
        category_groups = CategoryGroup.with_sub_categories.select { |cg| cg.sub_categories.with_indicators.count > 0 }
        render json: category_groups
      end

      api :GET, '/topic_city/:year/:indicator_slug', 'Fetch detailed data of topic'
      param :year, String, :desc => 'year', :required => true
      param :indicator_slug, String, :desc => 'indicator_slug', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year in city area
        response data has detailed data for indicator and specific year
      EOS

      def city_show
        @data = Resource.includes(:demo_group, :uploader, :indicator)
                  .where(year_from: params[:year] .. params[:year])
                  .where(geo_group_id: GeoGroup.find_by_geography('City'))
                  .joins(:indicator).where(indicators: {slug: params[:indicator_slug]})

        render json: @data, each_serializer: TopicCitySerializer
      end

      api :GET, '/topic_area/:year/:indicator_slug', 'Fetch detailed data of topic regarding year'
      param :year, String, :desc => 'year', :required => true
      param :indicator_slug, String, :desc => 'indicator_id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year in city area
        response data has detailed data for indicator and year
      EOS

      def area_show
        @data = Resource.includes(:uploader, :indicator, :geo_group, :demo_group)
                  .where(year_from: params[:year]..params[:year])
                  .where(indicator_id: Indicator.find_by_slug(params[:indicator_slug]))
                  .where.not(geo_group_id: GeoGroup.find_by_geography('City'))

        render json: @data, each_serializer: TopicAreaSerializer
      end

      api :GET, '/topic_detail/:indicator_slug', 'Fetch detailed data of topic for trend'
      param :indicator_slug, String, :desc => 'indicator slug', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for topic
        response data has detailed data for indicator(for trend all year data)
      EOS

      def trend
        indicator     = Indicator.find_by_slug(params[:indicator_slug])
        indicator     = nil if indicator.try(:sub_category).try(:slug) == SubCategory::SLUG_INDICES
        @data         = Resource.includes(:demo_group, :geo_group).where(indicator_id: indicator)
        static        = @data.first
        static_header = []
        if static.present?
          static_header << { :name => static.indicator.name, :category => static.category_group.name, :sub_category => static.sub_category.name, :slug => static.indicator.slug, :id => static.indicator.id }
        end

        @demo_list = DemoGroup.joins("INNER JOIN resources ON resources.demo_group_id = demo_groups.id AND resources.indicator_id = #{ indicator.id }").flatten.uniq

        render json: {
          static_header: static_header,
          data: ActiveModel::Serializer::ArraySerializer.new(@data, serializer: TopicDetailSerializer),
          demo_list: ActiveModel::Serializer::ArraySerializer.new(@demo_list, serializer: DemoListSerializer)
        }
      end

      api :GET, '/topic_demo/:indicator_slug/:demo_slug', 'Fetch trend data regarding demography'
      param :indicator_slug, String, :desc => 'indicator_slug', :required => true
      param :demo_slug, String, :desc => 'demography slug', :required => true
      formats ['json']
      description <<-EOS
        == Fecth detailed data for demography
        response data has detailed data for demography(for trend all year data)
      EOS

      def demo
        demo_group = DemoGroup.where("LOWER(demography) = ?", params[:demo_slug])
        render json: [] and return unless demo_group

        indicator_id = Indicator.find_by_slug(params[:indicator_slug])
        @data = Resource.includes(:category_group, :sub_category, :indicator, :demo_group).where(indicator_id: indicator_id, demo_group_id: demo_group.pluck(:id))

        render json: @data, each_serializer: TopicDemoSerializer
      end

      api :GET, '/topic_recent/:indicator_slug', 'Fetch detailed data of recent topic'
      param :indicator_slug, String, :desc => 'indicator slug', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and recent year
        response data has detailed data for indicator and recent year
      EOS
      def recent
        year  = Resource.where(indicator_id: Indicator.find_by(slug: params[:indicator_slug])).maximum('year_to')
        @data = Resource.includes(:category_group, :sub_category, :demo_group)
                        .where(year_from: year..year)
                        .where(indicator_id: Indicator.find_by(slug: params[:indicator_slug]))

        render json: @data, each_serializer: TopicRecentSerializer
      end

      api :GET, '/topic_info/:geo_slug/:indicator_slug', 'Fetch detailed data of topic for community area'
      param :indicator_slug, String, :desc => 'indicator slug', :required => true
      param :geo_slug, String, :desc => 'geo_slug', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for community area
      EOS
      def info
        @area_data     = Resource.includes(:category_group, :sub_category, :indicator, :demo_group)
                                 .where(indicator_id: Indicator.find_by_slug(params[:indicator_slug]),
                                  geo_group_id: GeoGroup.find_by_slug(params[:geo_slug])).select { |resource| resource.year_to == resource.year_from }
        @city_data     = Resource.includes(:category_group, :sub_category, :indicator, :demo_group)
                                 .where(indicator_id: Indicator.find_by_slug(params[:indicator_slug]), geo_group_id: GeoGroup.find_by_slug('chicago'))

        render json: {
          :area_data => ActiveModel::Serializer::ArraySerializer.new(@area_data, serializer: TopicAreaInfoSerializer),
          :city_data => ActiveModel::Serializer::ArraySerializer.new(@city_data, serializer: TopicCityInfoSerializer)
        }
      end
    end
  end
end
