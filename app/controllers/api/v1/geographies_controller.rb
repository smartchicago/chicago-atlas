module Api
  module V1
    class GeographiesController < ApiController
      include ApplicationHelper
      # cache_store :index, :show, :show_dataset, :show_death_dataset, :show_demographic_dataset, :show_insurance_dataset, :show_provider_dataset, :resources_json

      #returns the array of community_areas and zip_codes
      def index
        @community_areas  =   Geography.select("geographies.name, geographies.slug, count(intervention_locations.community_area_id) as resource_cnt")
                              .joins("LEFT JOIN intervention_locations on intervention_locations.community_area_id = geographies.id")
                              .group("geographies.id")
                              .where("geo_type = 'Community Area'")
                              .order("name").all

        @zip_codes        =   Geography.where("geo_type = 'Zip'").order("name").all

        # render :json => {:community_areas => @community_areas, :zip_codes => @zip_codes}
        render json: @community_areas, each_serializer: GeographySerializer
      end

      #returns detailed information for community_areas and zip_codes
      def show
        @demographics_list        = ['Below Poverty Level', 'Crowded Housing', 'Dependency', 'No High School Diploma', 'Per capita income', 'Unemployment']
        @adjacent_zips            = []
        @adjacent_community_areas = []

        @geography  =   Geography.where(:slug => params[:id]).first || not_found
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

        # render :json => {:geography => @geography, :categories => @categories, :adjacent_zips => @adjacent_zips, :adjacent_community_areas => @adjacent_community_areas, :male_percent => @male_percent, :female_percent => @female_percent, :has_category => @has_category}
        render json: @categories

      end

      def show_dataset
        @current_menu = 'places'

        @geography = Geography.where(:slug => params[:geo_slug]).first || not_found
        @dataset = Dataset.where(:slug => params[:dataset_slug]).first || not_found

        respond_to do |format|
          format.json { render :json => fetch_chart_data(@dataset.id, @geography.id) }
          format.html { not_found }
        end
      end

      def show_death_dataset
        @current_menu = 'places' #?

        @geography = Geography.where(:slug => params[:geo_slug]).first || not_found
        @datasets = get_datasets(@geography.id, 2)

        death_dataset = []

        @datasets.each do |dataset|
          death_data = { :death_cause => dataset.name,
            :description => dataset.description,
            :death_stat => fetch_chart_data(dataset.id, @geography.id)[:data].first,
            :chicago_death_stat => fetch_chart_data(dataset.id, 100)[:data].first }
          death_dataset << death_data
        end

        respond_to do |format|
          format.json { render :json => {:location => @geography.slug, :death_cause_data => death_dataset} }
          format.html { not_found }
        end
      end

      def show_demographic_dataset
        @geography = Geography.where(:slug => params[:geo_slug]).first || not_found

        pop_2000 = fetch_demographic_age_data(2000, @geography.id)
        pop_2010 = fetch_demographic_age_data(2010, @geography.id)

        demographic_data_all = []

        pop_2000.each_index do |i|
          population_data = {
            :age_group => GlobalConstants::AGE_GROUPS[i],
            :pop_2000 => pop_2000[i],
            :pop_2010 => pop_2010[i]
          }
          demographic_data_all << population_data
        end

        respond_to do |format|
          format.json { render :json => {
            :location => @geography.slug,
            :demographic_data => demographic_data_all} }
          format.html { not_found }
        end
      end

      def show_insurance_dataset
        @geography = Geography.where(:slug => params[:geo_slug]).first || not_found
        cat = Category.find_by_name(params[:cat_name])

        insurance_area = fetch_custom_chart_data(@geography.id, cat.id, nil, [])
        insurance_chicago = fetch_custom_chart_data(100, cat.id, nil, [])
        group_labels = []

        all_data = []

        Dataset.where(:category_id => cat.id).each do |dataset|
          group_labels << dataset.name
        end

        group_labels.each_index do |i|
          data = {
            :group => group_labels[i],
            :uninsured_area => insurance_area[i],
            :uninsured_chicago => insurance_chicago[i]
          }
          all_data << data
        end

        respond_to do |format|
          format.json { render :json => {
            :area => @geography.slug,
            :uninsured_data_type => cat.name,
            :data => all_data
            } }
          format.html { not_found }
        end

      end

      def show_provider_dataset
        @geography = Geography.where(:slug => params[:geo_slug]).first || not_found
        @category = Category.where("name = 'Healthcare Providers'").first

        all_data = []

        professions = []
        Dataset.where(:category_id => @category.id).each { |dataset| professions << dataset.name }

        providers_area = fetch_custom_chart_data(@geography.id, nil, nil, professions)
        providers_chicago = fetch_custom_chart_data(100, nil, nil, professions)

        professions.each_index do |i|
          data = {
            :profession => professions[i],
            :providers_area => providers_area[i],
            :providers_chicago => providers_chicago[i]
          }
          all_data << data
        end

        respond_to do |format|
          format.json { render :json => {
            :area => @geography.slug,
            :data => all_data
            } }
          format.html { not_found }
        end

      end

      def show_resources
        @current_menu = 'places'
        @geography = Geography.where(:slug => params[:geo_slug]).first || not_found

        @dataset_url_fragment = ""

        # for specific location view
        if not params[:dataset_slug].nil?
          @dataset = Dataset.where(:slug => params[:dataset_slug]).first || not_found
          @dataset_url_fragment << "/#{@dataset.id}"
        end
      end

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

        respond_to do |format|
          format.json { render :json => resources_by_cat }
        end
      end
    end
  end
end
