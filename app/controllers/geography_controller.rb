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
  end

  def showdataset
    @current_menu = 'places'
    
    @geography = Geography.where(:slug => params[:geo_slug]).first || not_found
    @dataset = Dataset.where(:slug => params[:dataset_slug]).first || not_found

    respond_to do |format|
      format.html # render our template
      format.json { render :json => fetch_chart_data(@dataset.id, @geography.id) }
    end
  end

end
