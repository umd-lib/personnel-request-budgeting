class LaborRequestsController < ApplicationController
  include PersonnelRequestController
  before_action :set_labor_request, only: [:show, :edit, :update, :destroy]

  # GET /labor_requests
  # GET /labor_requests.json
  def index
    @q = LaborRequest.ransack(params[:q])
    @q.sorts = 'position_description' if @q.sorts.empty?

    results = @q.result
    policy_scoped = policy_scope(results)
    policy_ordered = sort_results(@q, policy_scoped)

    @labor_requests = policy_ordered.page(params[:page])
  end

  # GET /labor_requests/1
  # GET /labor_requests/1.json
  def show
  end

  # GET /labor_requests/new
  def new
    @labor_request = LaborRequest.new
  end

  # GET /labor_requests/1/edit
  def edit
  end

  # POST /labor_requests
  # POST /labor_requests.json
  def create
    @labor_request = LaborRequest.new(labor_request_params)

    respond_to do |format|
      if @labor_request.save
        format.html { redirect_to @labor_request, notice: 'Labor request was successfully created.' }
        format.json { render :show, status: :created, location: @labor_request }
      else
        format.html { render :new }
        format.json { render json: @labor_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /labor_requests/1
  # PATCH/PUT /labor_requests/1.json
  def update
    respond_to do |format|
      if @labor_request.update(labor_request_params)
        format.html { redirect_to @labor_request, notice: 'Labor request was successfully updated.' }
        format.json { render :show, status: :ok, location: @labor_request }
      else
        format.html { render :edit }
        format.json { render json: @labor_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labor_requests/1
  # DELETE /labor_requests/1.json
  def destroy
    @labor_request.destroy
    respond_to do |format|
      format.html { redirect_to labor_requests_url, notice: 'Labor request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_labor_request
      @labor_request = LaborRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def labor_request_params
      params.require(:labor_request).permit(
        :employee_type_id, :position_description, :request_type_id,
        :contractor_name, :number_of_positions, :hourly_rate, :hours_per_week,
        :number_of_weeks, :nonop_funds, :nonop_source, :department_id,
        :unit_id, :justification)
    end
end
