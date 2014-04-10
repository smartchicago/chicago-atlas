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

    if params[:dataset_slug].nil?
      @landing = true
      @display_geojson = Rails.cache.fetch('landing_display_geojson') { geography_empty_geojson } 
    
    elsif params[:dataset_slug] == "affordable_resources"
      @detail_url_fragment = "/resources"
      @display_geojson = Rails.cache.fetch('geography_resources_geojson') { geography_resources_geojson }
    else
      @current_dataset = Rails.cache.fetch("#{params[:dataset_slug]}_current_dataset") { Dataset.where("slug = '#{params[:dataset_slug]}'").first }
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
