class HospitalController < ApplicationController
  include ApplicationHelper

  def index
  	@hospitals = Provider.where("primary_type = 'Hospital'")
  end

  def show
  	@hospital = Provider.where(:slug => params[:slug]).first || not_found
    @area_summary = ''
    
    if @hospital.geometry != "none"

      if !@hospital.area_alt.empty?
        @area_summary = @hospital.area_alt
      else
      
        case @hospital.area_type
        when "Zip"
          summary_word = "zip codes"
        when "Community Areas"
          summary_word = "community areas"
        end

        # This is dumb, bad code that was writting because of other dumb bad code and 
        # time constraints. - AJB 13 OCT 2015
        a = @hospital.areas
        case
        when a.length == 1
          @area_summary = "#{@hospital.name} serves the #{summary_word.singularize} <a href='/place/#{get_zip_slug(a[0])}'>#{a[0]}</a>."
        when a.length == 2
          @area_summary = "#{@hospital.name} serves the #{summary_word} <a href='/place/#{get_zip_slug(a[0])}'>#{a[0]}</a> and <a href='/place/#{get_zip_slug(a[1])}'>#{a[1]}</a>."
        when a.length > 2
          areas = ""
          a[0..(a.length-2)].each do |zip|
            areas += "<a href='/place/#{get_zip_slug(zip)}'>#{zip}</a>, "
          end
          @area_summary = "#{@hospital.name} serves the #{summary_word} #{areas}and <a href='/place/#{get_zip_slug(a.last)}'>#{a.last}</a>."
        end

      end
    
    end

  end

end
