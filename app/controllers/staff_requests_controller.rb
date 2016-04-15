class StaffRequestsController < ApplicationController
  before_action :set_staff_request, only: [:show, :edit, :update, :destroy]

  # GET /staff_requests
  # GET /staff_requests.json
  def index
    @staff_requests = StaffRequest.paginate(page: params[:page])
  end

  # GET /staff_requests/1
  # GET /staff_requests/1.json
  def show
  end

  # GET /staff_requests/new
  def new
    @staff_request = StaffRequest.new
  end

  # GET /staff_requests/1/edit
  def edit
  end

  # POST /staff_requests
  # POST /staff_requests.json
  def create
    @staff_request = StaffRequest.new(staff_request_params)

    respond_to do |format|
      if @staff_request.save
        format.html { redirect_to @staff_request, notice: 'Staff request was successfully created.' }
        format.json { render :show, status: :created, location: @staff_request }
      else
        format.html { render :new }
        format.json { render json: @staff_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staff_requests/1
  # PATCH/PUT /staff_requests/1.json
  def update
    respond_to do |format|
      if @staff_request.update(staff_request_params)
        format.html { redirect_to @staff_request, notice: 'Staff request was successfully updated.' }
        format.json { render :show, status: :ok, location: @staff_request }
      else
        format.html { render :edit }
        format.json { render json: @staff_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_requests/1
  # DELETE /staff_requests/1.json
  def destroy
    @staff_request.destroy
    respond_to do |format|
      format.html { redirect_to staff_requests_url, notice: 'Staff request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_staff_request
      @staff_request = StaffRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_request_params
      params.require(:staff_request).permit(
        :employee_type_id, :position_description, :request_type_id,
        :annual_base_pay, :nonop_funds, :nonop_source, :department_id,
        :subdepartment_id, :justification)
    end
end
