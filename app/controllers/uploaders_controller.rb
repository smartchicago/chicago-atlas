class UploadersController < ApplicationController
  before_action :set_uploader, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /uploaders
  # GET /uploaders.json
  def index
    @uploaders = Uploader.all.sort_by{|m| m.name}
  end

  # GET /uploaders/1
  # GET /uploaders/1.json
  def show
     @uploader = Uploader.find(params[:id])
  end

  # GET /uploaders/new
  def new
    @uploader = Uploader.new
  end

  # GET /uploaders/1/edit
  def edit
  end

  # POST /uploaders
  # POST /uploaders.json
  def create
    @uploader = current_user.uploaders.build(uploader_params)
    content_type = uploader_params[:path].content_type
    if (content_type.include? "spreadsheet") || (content_type.include? "excel")
      @uploader.update_name(uploader_params[:path].original_filename)
      @uploader.initialize_state
      respond_to do |format|
        if @uploader.save
          @uploader.uploaded!
          UploadProcessingWorker.perform_async(@uploader.id)
          format.html { redirect_to root_path, notice: 'File successfully uploaded.' }
          format.json { render :show, status: :created, location: @uploader }
        else
          format.html { render :new }
          format.json { render json: @uploader.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to new_uploader_path
    end
  end

  # PATCH/PUT /uploaders/1
  # PATCH/PUT /uploaders/1.json
  def update
    @uploader.remove_resources
    @uploader.update_name(uploader_params[:path].original_filename)
    @uploader.initialize_state
    respond_to do |format|
      if @uploader.update(uploader_params)
        @uploader.uploaded!
        UploadProcessingWorker.perform_async(@uploader.id)
        format.html { redirect_to root_path, notice: 'File successfully updated.' }
        format.json { render :show, status: :ok, location: @uploader }
      else
        puts '---------------------------------'
        puts @uploader.errors
        format.html { render :edit  }
        format.json { render json: @uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploaders/1
  # DELETE /uploaders/1.json
  def destroy
    @uploader.destroy
    respond_to do |format|
      format.html { redirect_to uploaders_url, notice: 'Uploader was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uploader
      @uploader = Uploader.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def uploader_params
      params.require(:uploader).permit(:path, :comment)
    end

end
