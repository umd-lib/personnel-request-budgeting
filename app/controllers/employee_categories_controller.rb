class EmployeeCategoriesController < ApplicationController
  before_action :set_employee_category, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /employee_categories
  # GET /employee_categories.json
  def index
    authorize EmployeeCategory
    @q = EmployeeCategory.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @employee_categories = @q.result
  end

  # GET /employee_categories/1
  # GET /employee_categories/1.json
  def show
    authorize EmployeeCategory
  end

  # GET /employee_categories/new
  def new
    authorize EmployeeCategory
    @employee_category = EmployeeCategory.new
  end

  # GET /employee_categories/1/edit
  def edit
    authorize EmployeeCategory
  end

  # POST /employee_categories
  # POST /employee_categories.json
  # rubocop:disable Metrics/MethodLength
  def create
    authorize EmployeeCategory
    @employee_category = EmployeeCategory.new(employee_category_params)

    respond_to do |format|
      if @employee_category.save
        format.html { redirect_to @employee_category, notice: 'Employee category was successfully created.' }
        format.json { render :show, status: :created, location: @employee_category }
      else
        format.html { render :new }
        format.json { render json: @employee_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employee_categories/1
  # PATCH/PUT /employee_categories/1.json
  def update
    authorize EmployeeCategory
    respond_to do |format|
      if @employee_category.update(employee_category_params)
        format.html { redirect_to @employee_category, notice: 'Employee category was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee_category }
      else
        format.html { render :edit }
        format.json { render json: @employee_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_categories/1
  # DELETE /employee_categories/1.json
  def destroy
    authorize EmployeeCategory
    respond_to do |format|
      if delete
        format.html { redirect_to employee_categories_url, notice: 'Employee category was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to employee_categories_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current employee category was deleted. If the
    # employee category cannot be deleted due an
    # ActiveRecord::DeleteRestrictionError, populates @error_msg and
    # returns false.
    def delete
      @employee_category.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Employee category cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_employee_category
      @employee_category = EmployeeCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_category_params
      params.require(:employee_category).permit(:code, :name)
    end
end
