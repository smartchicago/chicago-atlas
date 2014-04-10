class HomeController < ApplicationController
  include ApplicationHelper

  caches_action :index

  def index
    @current_menu = 'home'
  end

  def map
    @current_menu = 'map'
    @landing = false
    @detail_url_fragment = ''
    @current_statistics = []

    @current_dataset_name = ''
    @current_dataset_description = ''
    @current_dataset_slug = ''
    @current_dataset_url = ''
    @current_dataset_start_year = Time.now.year
    @current_dataset_end_year = Time.now.year
    @map_colors = ['#08519C', '#3182BD', '#6BAED6', '#BDD7E7', '#EFF3FF']

    if params[:dataset_slug].nil?
      @landing = true
      @display_geojson = Rails.cache.fetch('landing_display_geojson') { geography_empty_geojson } 
    
    elsif params[:dataset_slug] == "affordable_resources"
      @detail_url_fragment = "/resources"
      @display_geojson = Rails.cache.fetch('affordable_resources_geojson') { geography_resources_geojson }
      
      @current_dataset_name = 'Affordable resources'
      @current_dataset_description = 'Number of affordable resource locations by Chicago community area.'
      @current_dataset_url = 'http://purplebinder.com/'
      @map_colors = ['#54278f', '#756bb1', '#9e9ac8', '#cbc9e2', '#f2f0f7']

      statistics = Geography
                      .select("count(geographies.id) as resource_cnt")
                      .joins("JOIN intervention_locations on intervention_locations.community_area_id = geographies.id")
                      .group("geographies.id")
                      .where("geo_type = 'Community Area'").all
      
      statistics.each do |s|
        unless s.resource_cnt.nil? or s.resource_cnt == 0
          @current_statistics << s.resource_cnt.to_i
        end
      end

    else
      @current_dataset = Rails.cache.fetch("#{params[:dataset_slug]}_current_dataset") { Dataset.where("slug = '#{params[:dataset_slug]}'").first }
      @current_dataset_name = @current_dataset.name
      @current_dataset_description = @current_dataset.description
      @current_dataset_slug = @current_dataset.slug
      @current_dataset_url = @current_dataset.url
      @current_dataset_start_year = @current_dataset.start_year
      @current_dataset_end_year = @current_dataset.end_year

      @current_category = Rails.cache.fetch("#{params[:dataset_slug]}_current_category") { Category.find(@current_dataset.category_id) }

      statistics = Rails.cache.fetch("#{params[:dataset_slug]}_statistics") { 
                    Statistic.select('value')
                             .joins('INNER JOIN geographies on geographies.id = statistics.geography_id')
                             .where('dataset_id = ?', @current_dataset.id).all }
      
      statistics.each do |s|
        unless s.value.nil? or s.value == 0
          @current_statistics << s.value
        end
      end
      
      @display_geojson = Rails.cache.fetch("#{params[:dataset_slug]}_display_geojson") { geography_geojson(@current_dataset.id) }
    end
    
    @categories = Rails.cache.fetch("#{params[:dataset_slug]}_categories") { 
                    Category.select('categories.id, categories.name, categories.description')
                            .where("datasets.data_type = 'condition'")
                            .joins('INNER JOIN datasets ON datasets.category_id = categories.id')
                            .group('categories.id, categories.name, categories.description')
                            .having('count(datasets.id) > 0')
                            .order("categories.name") }

    respond_to do |format|
      format.html # render our template
      format.json { render :json => @display_geojson }
    end

  end

  def partners
    @current_menu = 'partners'
  end

  def about
    @current_menu = 'about'
  end

end
