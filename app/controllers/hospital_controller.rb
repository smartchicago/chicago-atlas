class HospitalController < ApplicationController
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


        a = @hospital.areas
        case
        when a.length == 1
          @area_summary = "#{@hospital.name} serves the #{summary_word.singularize} #{a[0]}."
        when a.length == 2
          @area_summary = "#{@hospital.name} serves the #{summary_word} #{a[0]} and #{a[1]}"
        when a.length > 2
          areas = ""
          a[0..(a.length-2)].each do |zip|
            areas += "#{zip}, "
          end
          @area_summary = "#{@hospital.name} serves the #{summary_word} #{areas}and #{a.last}."
        end

      end
    
    end

  end
end
