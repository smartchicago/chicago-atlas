class UploadersController < ApplicationController
  before_action :set_uploader, only: [:show, :edit, :update, :destroy]
  # GET /uploaders
  # GET /uploaders.json
  def index
    @uploaders = Uploader.all
    @current   = Uploader.first
  end

  # GET /uploaders/1
  # GET /uploaders/1.json
  def show
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
    @uploader = Uploader.new(uploader_params)
    respond_to do |format|
      if @uploader.save
        @uploader.uploaded!
        @job_id = UploadProcessingWorker.perform_async(@uploader.id)
        format.html { redirect_to @uploader, notice: 'Uploader was successfully created.' }
        format.json { render :show, status: :created, location: @uploader }
      else
        format.html { render :new }
        format.json { render json: @uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploaders/1
  # PATCH/PUT /uploaders/1.json
  def update
    respond_to do |format|
      if @uploader.update(uploader_params)
        format.html { redirect_to @uploader, notice: 'Uploader was successfully updated.' }
        format.json { render :show, status: :ok, location: @uploader }
      else
        format.html { render :edit }
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
      params.require(:uploader).permit(:path)
    end
end
