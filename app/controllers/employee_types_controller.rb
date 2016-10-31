class EmployeeTypesController < ApplicationController
  before_action :set_employee_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /employee_types
  # GET /employee_types.json
  def index
    authorize EmployeeType
    @q = EmployeeType.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @employee_types = @q.result.includes(:employee_category)
  end

  # GET /employee_types/1
  # GET /employee_types/1.json
  def show
    authorize EmployeeType
  end

  # GET /employee_types/new
  def new
    authorize EmployeeType
    @employee_type = EmployeeType.new
  end

  # GET /employee_types/1/edit
  def edit
    authorize EmployeeType
  end

  # POST /employee_types
  # POST /employee_types.json
  # rubocop:disable Metrics/MethodLength
  def create
    authorize EmployeeType
    @employee_type = EmployeeType.new(employee_type_params)

    respond_to do |format|
      if @employee_type.save
        format.html { redirect_to @employee_type, notice: "Employee type #{@employee_type.description} was successfully created." }
        format.json { render :show, status: :created, location: @employee_type }
      else
        format.html { render :new }
        format.json { render json: @employee_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employee_types/1
  # PATCH/PUT /employee_types/1.json
  def update
    authorize EmployeeType
    respond_to do |format|
      if @employee_type.update(employee_type_params)
        format.html { redirect_to @employee_type, notice: "Employee type #{@employee_type.description} was successfully updated." }
        format.json { render :show, status: :ok, location: @employee_type }
      else
        format.html { render :edit }
        format.json { render json: @employee_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_types/1
  # DELETE /employee_types/1.json
  def destroy
    authorize EmployeeType
    respond_to do |format|
      if delete
        format.html { redirect_to employee_types_url, notice: "Employee type #{@employee_type.description} was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to employee_types_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current employee type was deleted. If the employee
    # type cannot be deleted due an ActiveRecord::DeleteRestrictionError,
    # populates @error_msg and returns false.
    def delete
      @employee_type.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Employee type cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_employee_type
      @employee_type = EmployeeType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_type_params
      params.require(:employee_type).permit(:code, :name, :employee_category_id)
    end
end
