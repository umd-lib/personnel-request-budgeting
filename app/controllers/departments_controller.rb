class DepartmentsController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /departments
  # GET /departments.json
  def index
    authorize Department
    @q = Department.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @departments = @q.result.includes(:division)
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
    authorize Department
  end

  # GET /departments/new
  def new
    authorize Department
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
    authorize Department
  end

  # POST /departments
  # POST /departments.json
  def create
    authorize Department
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: "Department #{@department.description} was successfully created." }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    authorize Department
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: "Department #{@department.description} was successfully updated." }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    authorize Department
    respond_to do |format|
      if delete
        format.html { redirect_to departments_url, notice: "Department #{@department.description} was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to departments_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current department was deleted. If the department
    # cannot be deleted due an ActiveRecord::DeleteRestrictionError, populates
    # @error_msg and returns false.
    def delete
      @department.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Department cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:code, :name, :division_id)
    end
end
