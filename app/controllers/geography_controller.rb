class GeographyController < ApplicationController
  include ApplicationHelper

  caches_action :index, :show, :showdataset

  def index
    @community_areas = Geography.where("geo_type = 'Community Area'")
                                .order("name").all
    @zip_codes = Geography.where("geo_type = 'Zip'")
                                .order("name").all
  end

  def show
    @geography = Geography.where(:slug => params[:slug]).first
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
    @geography = Geography.where(:slug => params[:geo_slug]).first
    @dataset = Dataset.where(:slug => params[:dataset_slug]).first
  end

end
