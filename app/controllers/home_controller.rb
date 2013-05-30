class HomeController < ApplicationController
  include ApplicationHelper

  def index
  end

  def map
    if params[:dataset_slug].nil?
      #@current_dataset = Dataset.order("name").first
      #redirect_to :action => "map", :dataset_slug => @current_dataset.slug
      redirect_to :action => "map", :dataset_slug => "births_birth_rate"
    else
      @current_dataset = Dataset.where("slug = '#{params[:dataset_slug]}'").first
      @current_category = Category.find(@current_dataset.category_id)

      statistics = Statistic.select('value')
                            .joins('INNER JOIN geographies on geographies.id = statistics.geography_id')
                            .where('dataset_id = ?', @current_dataset.id).all
      @current_statistics = []
      statistics.each do |s|
        unless s.value.nil? or s.value == 0
          @current_statistics << s.value
        end
      end
      
      @display_geojson = geography_geojson(@current_dataset.id)
      @categories = Category.select('categories.id, categories.name, categories.description')
                            .where("datasets.data_type = 'condition'")
                            .joins('INNER JOIN datasets ON datasets.category_id = categories.id')
                            .group('categories.id, categories.name, categories.description')
                            .having('count(datasets.id) > 0')
                            .order("categories.name")

    end
  end

end
