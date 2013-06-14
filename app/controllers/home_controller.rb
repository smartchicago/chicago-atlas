class HomeController < ApplicationController
  include ApplicationHelper

  def index
  end

  def map
    @landing = false
    @dataset_slug = ''
    @dataset_name = ''
    @dataset_description = ''
    @dataset_start_year = ''
    @dataset_end_year = ''
    @current_statistics = []

    if params[:dataset_slug].nil?
      @landing = true
      @display_geojson = geography_empty_geojson
    else
      @current_dataset = Dataset.where("slug = '#{params[:dataset_slug]}'").first
      @dataset_slug = @current_dataset.slug
      @dataset_name = @current_dataset.name
      @dataset_description = @current_dataset.description
      @dataset_start_year = @current_dataset.start_year
      @dataset_end_year = @current_dataset.end_year

      @current_category = Category.find(@current_dataset.category_id)

      statistics = Statistic.select('value')
                            .joins('INNER JOIN geographies on geographies.id = statistics.geography_id')
                            .where('dataset_id = ?', @current_dataset.id).all
      
      statistics.each do |s|
        unless s.value.nil? or s.value == 0
          @current_statistics << s.value
        end
      end
      
      @display_geojson = geography_geojson(@current_dataset.id)
    end
    @categories = Category.select('categories.id, categories.name, categories.description')
                          .where("datasets.data_type = 'condition'")
                          .joins('INNER JOIN datasets ON datasets.category_id = categories.id')
                          .group('categories.id, categories.name, categories.description')
                          .having('count(datasets.id) > 0')
                          .order("categories.name")

  end

end
