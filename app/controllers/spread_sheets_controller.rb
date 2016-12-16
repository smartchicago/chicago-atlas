class SpreadSheetsController < ApplicationController
  before_action :set_spread_sheet, only: [:show, :edit, :update, :destroy]

  # GET /spread_sheets
  # GET /spread_sheets.json
  def index
    @spread_sheets = SpreadSheet.all
  end

  # GET /spread_sheets/1
  # GET /spread_sheets/1.json
  def show
  end

  # GET /spread_sheets/new
  def new
    @spread_sheet = SpreadSheet.new
  end

  # GET /spread_sheets/1/edit
  def edit
  end

  # POST /spread_sheets
  # POST /spread_sheets.json
  def create
    @spread_sheet = SpreadSheet.new(spread_sheet_params)

    respond_to do |format|
      if @spread_sheet.save
        format.html { redirect_to @spread_sheet, notice: 'Spread sheet was successfully created.' }
        format.json { render :show, status: :created, location: @spread_sheet }
      else
        format.html { render :new }
        format.json { render json: @spread_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spread_sheets/1
  # PATCH/PUT /spread_sheets/1.json
  def update
    respond_to do |format|
      if @spread_sheet.update(spread_sheet_params)
        format.html { redirect_to @spread_sheet, notice: 'Spread sheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @spread_sheet }
      else
        format.html { render :edit }
        format.json { render json: @spread_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spread_sheets/1
  # DELETE /spread_sheets/1.json
  def destroy
    @spread_sheet.destroy
    respond_to do |format|
      format.html { redirect_to spread_sheets_url, notice: 'Spread sheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spread_sheet
      @spread_sheet = SpreadSheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spread_sheet_params
      params.require(:spread_sheet).permit(:name, :src)
    end
end
