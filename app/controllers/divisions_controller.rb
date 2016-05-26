class DivisionsController < ApplicationController
  before_action :set_division, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /divisions
  # GET /divisions.json
  def index
    authorize Division
    @q = Division.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @divisions = @q.result
  end

  # GET /divisions/1
  # GET /divisions/1.json
  def show
    authorize Division
  end

  # GET /divisions/new
  def new
    authorize Division
    @division = Division.new
  end

  # GET /divisions/1/edit
  def edit
    authorize Division
  end

  # POST /divisions
  # POST /divisions.json
  # rubocop:disable Metrics/MethodLength
  def create
    authorize Division
    @division = Division.new(division_params)

    respond_to do |format|
      if @division.save
        format.html { redirect_to @division, notice: 'Division was successfully created.' }
        format.json { render :show, status: :created, location: @division }
      else
        format.html { render :new }
        format.json { render json: @division.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /divisions/1
  # PATCH/PUT /divisions/1.json
  def update
    authorize Division
    respond_to do |format|
      if @division.update(division_params)
        format.html { redirect_to @division, notice: 'Division was successfully updated.' }
        format.json { render :show, status: :ok, location: @division }
      else
        format.html { render :edit }
        format.json { render json: @division.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /divisions/1
  # DELETE /divisions/1.json
  def destroy
    authorize Division
    respond_to do |format|
      if delete
        format.html { redirect_to divisions_url, notice: 'Division was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to divisions_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current division was deleted. If the division
    # cannot be deleted due an ActiveRecord::DeleteRestrictionError, populates
    # @error_msg and returns false.
    def delete
      @division.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Division cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_division
      @division = Division.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def division_params
      params.require(:division).permit(:code, :name)
    end
end
