class ContractorRequestsController < ApplicationController
  before_action :set_contractor_request, only: [:show, :edit, :update, :destroy]

  # GET /contractor_requests
  # GET /contractor_requests.json
  def index
    @contractor_requests = ContractorRequest.all
  end

  # GET /contractor_requests/1
  # GET /contractor_requests/1.json
  def show
  end

  # GET /contractor_requests/new
  def new
    @contractor_request = ContractorRequest.new
  end

  # GET /contractor_requests/1/edit
  def edit
  end

  # POST /contractor_requests
  # POST /contractor_requests.json
  def create
    @contractor_request = ContractorRequest.new(contractor_request_params)

    respond_to do |format|
      if @contractor_request.save
        format.html { redirect_to @contractor_request, notice: 'Contractor request was successfully created.' }
        format.json { render :show, status: :created, location: @contractor_request }
      else
        format.html { render :new }
        format.json { render json: @contractor_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contractor_requests/1
  # PATCH/PUT /contractor_requests/1.json
  def update
    respond_to do |format|
      if @contractor_request.update(contractor_request_params)
        format.html { redirect_to @contractor_request, notice: 'Contractor request was successfully updated.' }
        format.json { render :show, status: :ok, location: @contractor_request }
      else
        format.html { render :edit }
        format.json { render json: @contractor_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contractor_requests/1
  # DELETE /contractor_requests/1.json
  def destroy
    @contractor_request.destroy
    respond_to do |format|
      format.html { redirect_to contractor_requests_url, notice: 'Contractor request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_contractor_request
      @contractor_request = ContractorRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contractor_request_params
      params.require(:contractor_request).permit(
        :employee_type_id, :position_description, :request_type_id,
        :contractor_name, :number_of_months, :annual_base_pay,
        :nonop_funds, :nonop_source, :department_id, :subdepartment_id,
        :justification)
    end
end
