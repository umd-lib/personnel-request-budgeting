class SubdepartmentsController < ApplicationController
  before_action :set_subdepartment, only: [:show, :edit, :update, :destroy]

  # GET /subdepartments
  # GET /subdepartments.json
  def index
    @q = Subdepartment.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @subdepartments = @q.result
  end

  # GET /subdepartments/1
  # GET /subdepartments/1.json
  def show
  end

  # GET /subdepartments/new
  def new
    @subdepartment = Subdepartment.new
  end

  # GET /subdepartments/1/edit
  def edit
  end

  # POST /subdepartments
  # POST /subdepartments.json
  def create
    @subdepartment = Subdepartment.new(subdepartment_params)

    respond_to do |format|
      if @subdepartment.save
        format.html { redirect_to @subdepartment, notice: 'Subdepartment was successfully created.' }
        format.json { render :show, status: :created, location: @subdepartment }
      else
        format.html { render :new }
        format.json { render json: @subdepartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subdepartments/1
  # PATCH/PUT /subdepartments/1.json
  def update
    respond_to do |format|
      if @subdepartment.update(subdepartment_params)
        format.html { redirect_to @subdepartment, notice: 'Subdepartment was successfully updated.' }
        format.json { render :show, status: :ok, location: @subdepartment }
      else
        format.html { render :edit }
        format.json { render json: @subdepartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subdepartments/1
  # DELETE /subdepartments/1.json
  def destroy
    respond_to do |format|
      if delete
        format.html { redirect_to subdepartments_url, notice: 'Subdepartment was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to subdepartments_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current subdepartment was deleted. If the
    # subdepartment cannot be deleted due an
    # ActiveRecord::DeleteRestrictionError, populates @error_msg and
    # returns false.
    def delete
      @subdepartment.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Subdepartment cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_subdepartment
      @subdepartment = Subdepartment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subdepartment_params
      params.require(:subdepartment).permit(:code, :name, :department_id)
    end
end
