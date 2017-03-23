module Api
  module V1
    class GeographiesController < ApiController
      include ApplicationHelper

      api :GET, '/places', 'Fetch community_areas and zip codes list'
      formats ['json']
      description <<-EOS
        == Fetch community areas and zip codes list
          This API is used to fetch community areas and zip codes list
          Response data is composed of community_areas list and zip_codes list
      EOS
      def index
        @community_areas  =   Geography.select("geographies.geo_type, geographies.name, geographies.slug, geographies.geometry, geographies.centroid, geographies.part, count(intervention_locations.community_area_id) as resource_cnt")
                                .joins("LEFT JOIN intervention_locations on intervention_locations.community_area_id = geographies.id")
                                .group("geographies.id")
                                .where("geo_type = 'Community Area'")
                                .order("name").all

        @zip_codes        =   Geography.where("geo_type = 'Zip'").order("name").all

        render :json => {:community_areas => @community_areas, :zip_codes => @zip_codes}
      end

      api :GET, '/place/:geo_slug', 'Fetch community_area/zip_code details'
      formats ['json']
      param :geo_slug, String, :desc => 'community_area slug or zip code', :required => true
      description <<-EOS
        == Fetch community area details using community area slug or zip code
          This API is used to fetch community area or zip code details.
          It has basic info for community area or zip code.
          Detailed charts and statistics data can be get using detailed apis.
          This API has only basic info for community area or zip code.
      EOS
      def show
        @demographics_list        = ['Below Poverty Level', 'Crowded Housing', 'Dependency', 'No High School Diploma', 'Per capita income', 'Unemployment']
        @adjacent_zips            = []
        @adjacent_community_areas = []
        @geography  =  Geography.where(:slug => params[:geo_slug]).first || not_found
        @categories =   Category.select('categories.id, categories.name, categories.description')
                              .joins('INNER JOIN datasets ON datasets.category_id = categories.id')
                              .joins('INNER JOIN statistics ON datasets.id = statistics.dataset_id')
                              .where("statistics.geography_id = ?", @geography.id)
                              .where("datasets.data_type = 'condition'")
                              .group('categories.id, categories.name, categories.description')
                              .having('count(datasets.id) > 0')
                              .order("categories.name")

        male_pop    =   @geography.population_by_sex('MALE')
        female_pop  =   @geography.population_by_sex('FEMALE')
        population  =   @geography.population(2010)

        @male_percent   = (male_pop.to_f / (male_pop + female_pop) * 100).round(1)
        @female_percent = (female_pop.to_f / (male_pop + female_pop) * 100).round(1)

        eval(@geography.adjacent_zips).each do |z|
          @adjacent_zips << Geography.find(z)
        end

        @adjacent_zips = @adjacent_zips.sort_by { |z| z[:name] }

        eval( @geography.adjacent_community_areas).each do |a|
          @adjacent_community_areas << Geography.find(a)
        end

        @adjacent_community_areas   = @adjacent_community_areas.sort_by { |a| a[:name] }
        @has_category               = @geography.has_category("All Uninsured")

        indicator  = Indicator.find_by_slug('childopportunityindex')
        geo_group  = GeoGroup.find_by_slug(params[:geo_slug])
        resource   = Resource.find_by(geo_group_id: geo_group.id, indicator_id: indicator.id) unless indicator.blank?
        child      = resource.demo_group.name unless resource.blank?
        categories = CategoryGroup.with_sub_categories.select { |cg| cg.sub_categories.with_indicators.count > 0 }

        render :json => {
          :geography => @geography,
          :adjacent_zips => @adjacent_zips,
          :adjacent_community_areas => @adjacent_community_areas,
          :male_percent => @male_percent,
          :female_percent => @female_percent,
          :has_category => @has_category,
          :total_population => population,
          :child_opportunity_index => child,
          :categories => categories
        }
      end

      def show_dataset
        @geography  = Geography.where(:slug => params[:geo_slug]).first || not_found
        @dataset    = Dataset.where(:slug => params[:dataset_slug]).first || not_found

        render :json => fetch_chart_data(@dataset.id, @geography.id)
      end

      api :GET, '/place/category/:cat_id/:geo_slug', 'Fetch category dataset using category id and community area/zip code'
      formats ['json']
      param :geo_slug, String, :desc => 'community_area slug or zip code', :required => true
      param :cat_id, String, :desc => 'category_id', :required => true
      description <<-EOS
        == Fetch category dataset using category id and community area/zip code
        category id is index number of category table and community area/zip code is slug.
        It has useful data for chart.
      EOS
      def show_category_dataset
        @geography  = Geography.where(:slug => params[:geo_slug]).first || not_found
        @datasets   = get_datasets(@geography.id, params[:cat_id])

        death_dataset = []

        @datasets.each do |dataset|
          death_data = {
            :death_cause        => dataset.name,
            :description        => dataset.description,
            :death_stat         => fetch_chart_data(dataset.id, @geography.id)[:data].first,
            :chicago_death_stat => fetch_chart_data(dataset.id, 100)[:data].first }

          death_dataset << death_data
        end

        render :json => {:location => @geography.slug, :death_cause_data => death_dataset}
      end

      api :GET, '/place/demography/:geo_slug', 'Fetch demography chart info of community_area or zip code'
      formats ['json']
      param :geo_slug, String, :desc => 'community_area slug or zip code', :required => true
      description <<-EOS
        == Fetch demography info for community_area or zip code
          This api gets detailed domography info for community_area or zip code.
          You can get the chart info too(map box) using this api.
          The result can be easily used on map box.
      EOS
      def show_demographic_dataset
        @geography = Geography.where(:slug => params[:geo_slug]).first || not_found
        pop_2000 = fetch_demographic_age_data(2000, @geography.id)
        pop_2010 = fetch_demographic_age_data(2010, @geography.id)

        demographic_data_all = []

        pop_2000.each_index do |i|
          population_data = {
            :age_group  => GlobalConstants::AGE_GROUPS[i],
            :pop_2000   => pop_2000[i],
            :pop_2010   => pop_2010[i]
          }

          demographic_data_all << population_data
        end

        total_population_data = {
          :pop_2000 => @geography.population(2000),
          :pop_2010 => @geography.population(2010)
        }

        @demographics_list = ['Below Poverty Level', 'Crowded Housing', 'Dependency', 'No High School Diploma', 'Per capita income', 'Unemployment']
        @topics_data       = []
        @demographics_list.each_with_index do |element, index|
          detailed_data = {
            :title => element,
            :data  => @geography.demographic_by_name(element)
          }
          @topics_data << detailed_data
        end

        render :json => {
          :location => @geography.slug,
          :demographic_data => demographic_data_all,
          :total_population_data => total_population_data,
          :topics_data => @topics_data
        }
      end

      api :GET, '/place/insurance/:cat_id/:geo_slug', 'Fetch insurance info regarding community area or zip code and category name'
      formats ['json']
      param :geo_slug, String, :desc => 'community_area slug or zip code', :required => true
      param :cat_id, String, :desc => 'category id', :required => true
      description <<-EOS
        == Fetch insurance data using category id and community area / zip code
        Result data is easily used on chart and it has info for insurance
      EOS
      def show_insurance_dataset
        @geography        = Geography.where(:slug => params[:geo_slug]).first || not_found
        cat               = Category.find_by_id(params[:cat_id])
        insurance_area    = fetch_custom_chart_data(@geography.id, cat.id, nil, [])
        insurance_chicago = fetch_custom_chart_data(100, cat.id, nil, [])
        group_labels      = []
        all_data          = []

        Dataset.where(:category_id => cat.id).each do |dataset|
          group_labels << dataset.name
        end

        group_labels.each_index do |i|
          data = {
            :group              => group_labels[i],
            :uninsured_area     => insurance_area[i],
            :uninsured_chicago  => insurance_chicago[i]
          }
          all_data << data
        end

        render :json => {
          :area => @geography.slug,
          :uninsured_data_type => cat.name,
          :data => all_data
          }
      end

      api :GET, '/place/providers/:geo_slug', 'Fetch provider info using community area or zip code'
      formats ['json']
      param :geo_slug, String, :desc => 'community_area slug or zip code', :required => true
      description <<-EOS
        == Fetch provides info using community_area or zip code.
        It can be easily used on charts.
      EOS
      def show_provider_dataset
        @geography  = Geography.where(:slug => params[:geo_slug]).first || not_found
        @category   = Category.where("name = 'Healthcare Providers'").first

        all_data    = []
        professions = []

        Dataset.where(:category_id => @category.id).each { |dataset| professions << dataset.name }
        providers_area    = fetch_custom_chart_data(@geography.id, nil, nil, professions)
        providers_chicago = fetch_custom_chart_data(100, nil, nil, professions)

        professions.each_index do |i|
          data = {
            :profession         => professions[i],
            :providers_area     => providers_area[i],
            :providers_chicago  => providers_chicago[i]
          }
          all_data << data
        end

        respond_to do |format|
          format.json { render :json => {
            :area => @geography.slug,
            :data => all_data
            }
          }

          format.html { not_found }
        end

      end

      def show_resources
        @geography            = Geography.where(:slug => params[:geo_slug]).first || not_found
        @dataset_url_fragment = ""

        # for specific location view
        if not params[:dataset_slug].nil?
          @dataset = Dataset.where(:slug => params[:dataset_slug]).first || not_found
          @dataset_url_fragment << "/#{@dataset.id}"
        end
      end

      api :GET, '/resources(/:dataset_id)/:north/:east/:south/:west', 'Fetch resources info for community_area/zip code'
      api :GET, '/resources(/:dataset_id)/:community_area_slug', 'Fetch resources info for community_area/zip code'
      formats ['json']
      param :geo_slug, String, :desc => 'community_area slug or zip code'
      param :north, String, :desc => 'north'
      param :east, String, :desc => 'east'
      param :southh, String, :desc => 'south'
      param :west, String, :desc => 'west'
      param :dataset_slug, String, :desc => 'dataset slug'
      param :community_area_slug, String, :desc => 'community_area_slug'
      description <<-EOS
        == Fetch community area or zip code resources
          This api fetches the detailed resources info of community_area or zip code.
          It has detailed info for resources placed in community area or zip code.
      EOS
      def resources_json
        dataset_id = params[:dataset_id]
        # send boundary with [ north, east, south, west ]
        bounds = [params[:north], params[:east], params[:south], params[:west] ]
        community_area = params[:community_area_slug]
        resources = InterventionLocation

        if dataset_id
          resources = resources.where('dataset_id = ?', dataset_id)
        end

        if community_area
          resources = resources
                        .joins("JOIN geographies on intervention_locations.community_area_id = geographies.id")
                        .where("geographies.slug = ?", community_area)
        end

        if bounds[0] != nil
          bounds[0] = bounds[0].gsub(/[,]/, '.').to_f
          bounds[1] = bounds[1].gsub(/[,]/, '.').to_f
          bounds[2] = bounds[2].gsub(/[,]/, '.').to_f
          bounds[3] = bounds[3].gsub(/[,]/, '.').to_f

          resources = resources.where("latitude < #{bounds[0]} AND longitude < #{bounds[1]} AND latitude > #{bounds[2]} AND longitude > #{bounds[3]}")
        end

        resources = resources.order('program_name, organization_name')

        # convert in to a JSON object grouped by category
        resources_by_cat = [{:category => 'all', :resources => []}]
        resources_all = []
        resources.each do |r|
          categories = eval(r[:categories])
          categories.each do |c|
            if resources_by_cat.select {|r_c| r_c[:category] == c }.empty?
              resources_by_cat << {:category => c, :resources => []}
            end
            unless r[:address].empty?
              resources_by_cat.select {|r_c| r_c[:category] == c }.first[:resources] << r
              resources_all << r
            end
          end
        end

        resources_all = resources_all.uniq
        resources_by_cat.select {|r_c| r_c[:category] == 'all' }.first[:resources] = resources_all
        resources_by_cat = resources_by_cat.sort_by { |r_c| r_c[:category] }

        resources_by_cat.each do |r_c|
          r_c[:resources] = r_c[:resources].sort_by { |r| r[:organization_name]}
        end

        render :json => { :resources_all => resources_all }
      end

      api :GET, '/resources_all(/:dataset_slug)', 'Fetch all resources'
      formats ['json']
      param :dataset_slug, String, :desc => 'dataset slug'
      description <<-EOS
        == Fetch all of the resources exists in chicago city.
      EOS
      def resources_all
        dataset_id  = params[:dataset_id]
        resources   = InterventionLocation

        resources_all = resources.all
        render :json => { :resources_all => resources_all, :geography =>  @geography, :dataset_url_fragment => @dataset_url_fragment, :dataset => @dataset }

      end

      api :GET, '/resources_category/:category_slug(/:dataset_slug)', 'Fetch all resources with category slug'
      formats ['json']
      param :dataset_slug, String, :desc => 'dataset slug'
      param :category_slug, String, :desc => 'category slug'
      description <<-EOS
        == Fetch all of the resources exists in chicago city with category slug.
      EOS
      def resources_category
        resources   = InterventionLocation

        resources = resources.order('program_name, organization_name')

        # convert in to a JSON object grouped by category
        resources_by_cat  = [{:category => params[:category_slug], :resources => []}]
        resources.each do |r|
          categories = eval(r[:categories])
          categories.each do |c|
            unless r[:address].empty?
              if c == params[:category_slug]
                resources_by_cat.select {|r_c| r_c[:category] == params[:category_slug]}.first[:resources] << r
              end
            end
          end
        end

        render :json => { :resources_by_cat => resources_by_cat}

      end

      api :GET, '/:geo_slug/:category_slug/community_area_detail', 'Fetch all community area details'
      formats ['json']
      param :geo_slug, String, :desc => 'geo slug'
      description <<-EOS
        == Fetch all of the community area details.
      EOS
      def community_area_detail
        geo_slug        = params[:geo_slug]
        category_slug   = params[:category_slug]
        geo_id          = GeoGroup.find_by_slug(geo_slug).id
        category        = CategoryGroup.where(slug: category_slug)
        render json: category, each_serializer: CommunityAreaDetailSerializer, geo_id: geo_id
      end
    end
  end
end
