module Api
  module V1
    class TopicsController < ApiController
      api :GET, '/topics', 'Fetch category, subcategory, indicators list'
      formats ['json']
      description <<-EOS
        == Fetch category, subcategory, indicators
      EOS
      def index
        category_groups = CategoryGroup.with_sub_categories.select { |cg| cg.sub_categories.with_indicators.count > 0 }
        render json: category_groups
      end

      api :GET, '/topic_city/:year/:indicator_slug', 'Fetch detailed data of topic'
      param :year, String, :desc => 'year', :required => true
      param :indicator_slug, String, :desc => 'indicator slug', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year in city area
        response data has detailed data for indicator and year
      EOS
      def city_show
        city  = GeoGroup.find_by_geography('City')
        @data = Resource.where("year_from <= ? AND year_to >= ?", params[:year], params[:year]).where(geo_group_id: city.id).select { |resource| resource.indicator.slug == params[:slug] }
        render json: @data, each_serializer: TopicCitySerializer
      end

      api :GET, '/topic_area/:year/:indicator_slug', 'Fetch detailed data of topic'
      param :year, String, :desc => 'year', :required => true
      param :indicator_slug, String, :desc => 'indicator id', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year in city area
        response data has detailed data for indicator and year
      EOS
      def area_show
        @data = Resource.where("year_from <= ? AND year_to >= ?", params[:year], params[:year]).where(indicator_id: Indicator.find_by_slug(params[:indicator_id]).id).where.not(geo_group_id: GeoGroup.find_by_geography('City').id)
        render json: @data, each_serializer: TopicAreaSerializer
      end

      api :GET, '/topic_detail/:indicator_slug', 'Fetch detailed data of topic for trend'
      param :indicator_slug, String, :desc => 'indicator slug', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior
        response data has detailed data for indicator(for trend all year data)
      EOS
      def trend
        slug          = params[:indicator_slug]
        indicator_id  = Indicator.find_by_slug(slug).id
        @data         = Resource.where(indicator_id: indicator_id)
        # @data         = Resource.eager_load(:demo_group,:category_group, :sub_category, :indicator)
        #                   .where('indicators.id = ?', indicator_id)
        @demo_list    = DemoGroup.select {|s| Resource.find_by(indicator_id: indicator_id, demo_group_id: s.id) != nil}
        # @demo_list    = DemoGroup
        #                   .select {
        #                     |s| Resource.eager_load(:demo_group, :indicator)
        #                       .find_by(indicator_id: indicator_id, demo_group_id: s.id)
        #                   }

        # @demo_list    = DemoGroup.eager_load(:resources)
        #                   .where('resources.id = ? AND resources.demo_group_id = ?', indicator_id, DemoGroup.ids)

        render json: {
          data: ActiveModel::Serializer::CollectionSerializer.new(@data, serializer: TopicDetailSerializer),
          demo_list: ActiveModel::Serializer::CollectionSerializer.new(@demo_list, serializer: DemoListSerializer)
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
      
        demo_slug = params[:demo_slug] ? params[:demo_slug].downcase : nil
      
        # demo_slug       = params[:demo_slug].downcase
        indicator_slug  = params[:indicator_slug]
        data            = Resource.select { |d| (d.demo_group.demography.downcase == demo_slug.downcase unless d.demo_group.blank?) && (d.indicator.slug == indicator_slug) }
        # data            = Resource.where(:demo_group['demography'] == demo_slug && indicator.slug == indicator_slug).find_each { |d| d }
        render json: data, each_serializer: TopicDemoSerializer
      end

      # def demo
      #   demo_slug       = params[:demo_slug]
      #   indicator_slug  = params[:indicator_slug]
      #   data = Resource.eager_load(:demo_group, :indicator, :category_group, :sub_category).where('lower(demo_groups.demography) = ? AND indicators.slug = ?', demo_slug.downcase, indicator_slug)
      #   render json: data, each_serializer: TopicDemoSerializer
      # end

      api :GET, '/topic_recent/:indicator_slug', 'Fetch detailed data of topic'
      param :indicator_slug, String, :desc => 'indicator slug', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for indicatior and year
        response data has detailed data for indicator and year
      EOS
      def recent
        slug  = params[:indicator_slug]
        index = Indicator.find_by(slug: slug).id
        year  = Resource.where(indicator_id: index).maximum('year_to')
        @data = Resource.where("year_from <= ? AND year_to >= ?", year, year).where(indicator_id: index)
        render json: @data
      end

      api :GET, '/topic_info/:geo_slug/:indicator_slug', 'Fetch detailed data of topic for community area'
      param :indicator_slug, String, :desc => 'indicator slug', :required => true
      param :geo_slug, String, :desc => 'geo_slug', :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for community area
      EOS
      def info
        indicator_slug = params[:indicator_slug]
        geo_slug       = params[:geo_slug]
        geo_group_id   = GeoGroup.find_by_slug(geo_slug)
        indicator_id   = Indicator.find_by_slug(indicator_slug)
        chicago_id     = GeoGroup.find_by_slug('chicago')
        @area_data     = Resource.where(indicator_id: indicator_id, geo_group_id: geo_group_id)
        @city_data     = Resource.where(indicator_id: indicator_id, geo_group_id: chicago_id)

        render json: {
          :area_data => ActiveModel::Serializer::ArraySerializer.new(@area_data, serializer: TopicAreaInfoSerializer),
          :demo_list => ActiveModel::Serializer::ArraySerializer.new(@city_data, serializer: TopicCityInfoSerializer)
        }
      end
    end
  end
end
