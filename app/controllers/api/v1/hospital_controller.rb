module Api
  module V1
    class HospitalController < ApiController
      include ApplicationHelper

      api :GET, '/hospitals', 'Fetch all of hospitals data'
      formats ['json']
      description <<-EOS
        == Fetch all of hospitals data.
      EOS
      def hospitals_all
        @hospitals  =   Provider.select("src_id",
                                                    "name",
                                                    "slug",
                                                    "primary_type",
                                                    "sub_type",
                                                    "addr_street",
                                                    "addr_city",
                                                    "addr_zip",
                                                    "contact_phone",
                                                    "lat_long").where("primary_type = 'Hospital'")
        render json: @hospitals
      end

      api :GET, '/:geo_slug/hospitals', 'Fetch hospitals data of community area or zip code'
      param :geo_slug, String, :desc => "community area or zip code", :required => true
      formats ['json']
      description <<-EOS
        == Fetch hospitals data of community area or zip code
        response data has all of the hospitals list and it's data for community area or zip code.
        Each hospitals detailed can be get using another api
      EOS
      def index
        @result     =   []
        @slug       =   params[:geo_slug]
        @geometry   =   Geography.find_by_slug(@slug)
        @hospitals  =   Provider.where("primary_type = 'Hospital'")
        @zips       =   @geometry.adjacent_zips

        @hospitals.each do |page|
          if @zips.include? page.addr_zip
            @result << page
          end
        end

        render json: @result
      end

      api :GET, '/hospital/:slug', 'Fetch detailed data of hospital'
      param :slug, String, :desc => "hospital slug", :required => true
      formats ['json']
      description <<-EOS
        == Fetch detailed data for hospital
        response data detailed data for hospital and it can be get using hospital slug.
      EOS
      def show
      	@hospital       = Provider.where(:slug => params[:slug]).first || not_found
        @area_summary   = ''

        if @hospital.geometry != "none"

          if !@hospital.area_alt.blank?
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

        @admissions_by_race         = fetch_provider_data(@hospital.src_id, "Admissions by Race")
        @admissions_by_ethnicity    = fetch_provider_data(@hospital.src_id, "Admissions by Ethnicity")
        @admissions_by_type         = fetch_sorted_provider_data(@hospital.src_id, "Admissions by Type")
        @admissions_by_age          = fetch_provider_data(@hospital.src_id, "Medical-Surgical Admissions By Age")
        @total_admissions           = @admissions_by_race[:values].sum
        @revenue_inpatient          = fetch_provider_data(@hospital.src_id, "Inpatient Revenue by Payment Type")
        @inpatient_total            = @revenue_inpatient[:values].sum
        @revenue_outpatient         = fetch_provider_data(@hospital.src_id, "Outpatient Revenue by Payment Type")
        @outpatient_total           = @revenue_outpatient[:values].sum
        @total_revenue              = @inpatient_total + @outpatient_total
        @charity_care               = fetch_provider_data(@hospital.src_id, "Actual Cost Charity Care")
        @inpatient_cc               = @charity_care[:values][@charity_care[:stats].index('Charity Care - Inpatient')]
        @outpatient_cc              = @charity_care[:values][@charity_care[:stats].index('Charity Care - Outpatient')]
        @finance_data               = { outpatient_total: @outpatient_total, inpatient_total: @inpatient_total, outpatient_cc: @outpatient_cc, inpatient_cc: @inpatient_cc }

        render :json => {:hospital => @hospital, :area_summary => @area_summary, :total_admissions =>  @total_admissions, :total_revenue => @total_revenue, :admissions_by_type => @admissions_by_type, :admissions_by_race => @admissions_by_race, :admissions_by_ethnicity => @admissions_by_ethnicity, :admissions_by_age => @admissions_by_age,
          :finance_data => @finance_data, :revenue_outpatient => @revenue_outpatient, :revenue_inpatient => @revenue_inpatient}
      end
    end
  end
end
