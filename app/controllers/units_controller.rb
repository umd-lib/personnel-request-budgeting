class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /units
  # GET /units.json
  def index
    authorize Unit
    @q = Unit.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @units = @q.result
  end

  # GET /units/1
  # GET /units/1.json
  def show
    authorize Unit
  end

  # GET /units/new
  def new
    authorize Unit
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
    authorize Unit
  end

  # POST /units
  # POST /units.json
  # rubocop:disable Metrics/MethodLength
  def create
    authorize Unit
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: "Unit #{@unit.description} was successfully created." }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    authorize Unit
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: "Unit #{@unit.description} was successfully updated." }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    authorize Unit
    respond_to do |format|
      if delete
        format.html { redirect_to units_url, notice: "Unit #{@unit.description} was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to units_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current unit was deleted. If the
    # unit cannot be deleted due an
    # ActiveRecord::DeleteRestrictionError, populates @error_msg and
    # returns false.
    def delete
      @unit.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Unit cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:code, :name, :department_id)
    end
end
