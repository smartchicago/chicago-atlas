class GeographyController < ApplicationController
  include ApplicationHelper

  caches_action :index, :show, :showdataset

  def index
    @current_menu = 'places'
    @community_areas = Geography.where("geo_type = 'Community Area'").order("name").all
    @zip_codes = Geography.where("geo_type = 'Zip'").order("name").all

    respond_to do |format|
      format.html # render our template
      format.json { render :json => {:community_areas => @community_areas, :zip_codes => @zip_codes} }
    end
  end

  def show
    @current_menu = 'places'

    @geography = Geography.where(:slug => params[:slug]).first || not_found

    @categories = Category.select('categories.id, categories.name, categories.description')
                          .joins('INNER JOIN datasets ON datasets.category_id = categories.id')
                          .joins('INNER JOIN statistics ON datasets.id = statistics.dataset_id')
                          .where("statistics.geography_id = ?", @geography.id)
                          .where("datasets.data_type = 'condition'")
                          .group('categories.id, categories.name, categories.description')
                          .having('count(datasets.id) > 0')
                          .order("categories.name")

    @demographics_list = ['Below Poverty Level', 'Crowded Housing', 'Dependency', 'No High School Diploma', 'Per capita income', 'Unemployment']
   
    male_pop = @geography.population_by_sex('MALE')
    female_pop = @geography.population_by_sex('FEMALE')

    @male_percent = (male_pop.to_f / (male_pop + female_pop) * 100).round(1)
    @female_percent = (female_pop.to_f / (male_pop + female_pop) * 100).round(1)

    @adjacent_zips = [] 
    eval(@geography.adjacent_zips).each do |z|
      @adjacent_zips << Geography.find(z)
    end
    @adjacent_zips = @adjacent_zips.sort_by { |z| z[:name] }

    @adjacent_community_areas = [] 
    eval(@geography.adjacent_community_areas).each do |a|
      @adjacent_community_areas << Geography.find(a)
    end
    @adjacent_community_areas = @adjacent_community_areas.sort_by { |a| a[:name] }
    
  end

  def show_dataset
    @current_menu = 'places'
    
    @geography = Geography.where(:slug => params[:geo_slug]).first || not_found
    @dataset = Dataset.where(:slug => params[:dataset_slug]).first || not_found

    respond_to do |format|
      format.html # render our template
      format.json { render :json => fetch_chart_data(@dataset.id, @geography.id) }
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

    resources = InterventionLocation

    if dataset_id
      resources = resources.where('dataset_id = ?', dataset_id)
    end

    if bounds
      bounds[0] = bounds[0].gsub(/[,]/, '.').to_f
      bounds[1] = bounds[1].gsub(/[,]/, '.').to_f
      bounds[2] = bounds[2].gsub(/[,]/, '.').to_f
      bounds[3] = bounds[3].gsub(/[,]/, '.').to_f

      resources = resources.where("latitude < #{bounds[0]} AND longitude < #{bounds[1]} AND latitude > #{bounds[2]} AND longitude > #{bounds[3]}")
    end

    resources.order('program_name, organization_name')

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
