class StaffRequestsController < ApplicationController
  include PersonnelRequestController
  before_action :set_staff_request, only: [:show, :edit, :update, :destroy]
  after_action :verify_policy_scoped, only: :index

  # GET /staff_requests
  # GET /staff_requests.json
  def index
    @q = StaffRequest.ransack(params[:q])
    @q.sorts = %w( division_code department_code unit_code employee_type_code ) if @q.sorts.empty?

    results = @q.result.includes(%i( division employee_type request_type unit ))
    @staff_requests = policy_scope(results.page(params[:page])) || []
  end

  # GET /staff_requests/1
  # GET /staff_requests/1.json
  def show
    authorize @staff_request
  end

  # GET /staff_requests/new
  def new
    authorize StaffRequest
    @staff_request = StaffRequest.new
  end

  # GET /staff_requests/1/edit
  def edit
    authorize @staff_request
  end

  # POST /staff_requests
  # POST /staff_requests.json
  # rubocop:disable Metrics/MethodLength
  def create
    @staff_request = StaffRequest.new(staff_request_params)
    authorize @staff_request

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
    authorize @staff_request
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
    authorize @staff_request
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
      allowed = [:employee_type_id, :position_description, :request_type_id,
                 :annual_base_pay, :nonop_funds, :nonop_source, :department_id,
                 :unit_id, :justification] + policy(@staff_request || StaffRequest.new).permitted_attributes
      params.require(:staff_request).permit(allowed)
    end
end
