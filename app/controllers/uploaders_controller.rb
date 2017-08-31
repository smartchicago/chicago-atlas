class UploadersController < ApplicationController
  before_action :set_uploader, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  require 'roo'

  def index
    @uploaders = Uploader.where(category: Uploader::TYPES[:default])
    @hc_uploaders = Uploader.where(category: Uploader::TYPES[:indicator_2_0])
  end

  def resources
    @uploaders = Uploader.where(category: Uploader::TYPES[:resources])
  end

  def indicators_map_colors
    @uploaders = Uploader.where(category: Uploader::TYPES[:indicator_map_color])
  end

  def health_care_indicators_index
     @uploader = Uploader.find_by_id(params[:id])
     @indicators = HcIndicator.where(uploader_id: params[:id]).paginate(:page => params[:page], :per_page => 16)
  end

  def resources_index
     @uploader = Uploader.find_by_id(params[:id])
     @resources = InterventionLocation.all.paginate(:page => params[:page], :per_page => 16)
  end

  def indicators_map_colors_index
    @uploader = Uploader.find_by_id(params[:id])
    @indicators_map_colors = IndicatorMapColour.all.paginate(:page => params[:page], :per_page => 16)
  end

  def show
     @uploader = Uploader.find(params[:id])
  end

  def new
    @previous_uploader = params[:previous_uploader] ? Uploader.find_by_id(params[:previous_uploader]) : nil
    @uploader = Uploader.new
    category = params[:category]
    if category
      @uploader.category = category
    end
  end

  def new_health_care
    @uploader = Uploader.new
    @uploader.category = Uploader::TYPES[:indicator_2_0]
    render :new
  end

  def new_description_template
    @uploader = Uploader.new
    @uploader.category = Uploader::TYPES[:description_template]
    render :new
  end

  def new_resources
    @uploader = Uploader.new
    @uploader.category = Uploader::TYPES[:resources]
    render :new
  end

  def new_indicators_map_colors
    @uploader = Uploader.new
    @uploader.category = Uploader::TYPES[:indicator_map_color]
    render :new
  end

  def edit
  end

  def create
    @uploader = current_user.uploaders.build(uploader_params)
    content_type = uploader_params[:path].original_filename.last(4)
    if (content_type.include? "csv") || (content_type.include? "xlsx")
      if @uploader.category != Uploader::TYPES[:default]
        previous_uploader = nil
      else
        previous_uploader = find_previous_uploader
      end
      if  !previous_uploader
        @uploader.update_name(uploader_params[:path].original_filename)
        @uploader.initialize_state
        respond_to do |format|
          if @uploader.save
            @uploader.uploaded!
            UploadProcessingWorker.perform_async(@uploader.id)
            if @uploader.category != Uploader::TYPES[:resources]
              format.html { redirect_to root_path, notice: 'File successfully uploaded.' }
              format.json { render :show, status: :created, location: @uploader }
            else
              format.html { redirect_to resources_uploaders_path, notice: 'File successfully uploaded.' }
              format.json { render :show, status: :created, location: @uploader }
            end
          else
            format.html { render :new }
            format.json { render json: @uploader.errors, status: :unprocessable_entity }
          end
        end
      else
        redirect_to new_uploader_path(previous_uploader: previous_uploader, category: @uploader.category)
      end
    else
     redirect_to new_uploader_path(category: @uploader.category)
    end
  end

  def update
    case @uploader.category
      when Uploader::TYPES[:default]
        @uploader.remove_resources
        Indicator.find(@uploader.indicator_id).destroy
      when Uploader::TYPES[:indicator_2_0]
        @uploader.remove_health_care_indicators
    end
    @uploader.update_name(uploader_params[:path].original_filename)
    @uploader.initialize_state
    respond_to do |format|
      if @uploader.update(uploader_params)
        @uploader.uploaded!
        UploadProcessingWorker.perform_async(@uploader.id)
        if @uploader.category != Uploader::TYPES[:resources]
          format.html { redirect_to root_path, notice: 'File successfully updated.' }
          format.json { render :show, status: :ok, location: @uploader }
        else
          format.html { redirect_to resources_uploaders_path, notice: 'File successfully uploaded.' }
          format.json { render :show, status: :created, location: @uploader }
        end
      else
        format.html { render :edit  }
        format.json { render json: @uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_health_care_indicators
    @uploader.remove_health_care_indicators
    @uploader.update_name(uploader_params[:path].original_filename)
    @uploader.initialize_state
    respond_to do |format|
      if @uploader.update(uploader_params)
        @uploader.uploaded!
        UploadProcessingWorker.perform_async(@uploader.id)
        format.html { redirect_to root_path, notice: 'File successfully updated.' }
        format.json { render :show, status: :ok, location: @uploader }
      else
        format.html { render :edit  }
        format.json { render json: @uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_indicator = Indicator.find_by_id(@uploader.indicator_id)
    if @uploader.category == Uploader::TYPES[:indicator_2_0]
      @uploader.remove_health_care_indicators
    elsif @uploader.category == Uploader::TYPES[:description_template]
      @uploader.remove_description_template
    elsif @uploader.category == Uploader::TYPES[:resources]
      @uploader.remove_intervention_location
    elsif @uploader.category == Uploader::TYPES[:indicator_map_color]
      @uploader.remove_indicators_map_colors
    end

    @uploader.destroy
    current_indicator.destroy if current_indicator
    respond_to do |format|
      format.html { redirect_to uploaders_url, notice: 'Uploader was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_uploader
      @uploader = Uploader.find(params[:id])
    end

    def uploader_params
      params.require(:uploader).permit(:path, :comment, :category)
    end

    def find_previous_uploader
      previous_uploader = nil
      if file = Roo::Spreadsheet.open(uploader_params[:path].path)
        total_count = file.last_row - 1
        if total_count > 1
          2.upto 2 do |row|
            indicator_name = file.cell(row, 'C').to_s
            indicator_slug  = CGI.escape(indicator_name.tr(' ', '-').tr('/', '-').tr(',', '-').downcase)
            if indicator = Indicator.find_by_slug(indicator_slug)
              previous_uploader = Uploader.find_by_indicator_id(indicator.id)
            end
          end
        end
      end
      previous_uploader
    end
end
