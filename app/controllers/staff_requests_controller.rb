# rubocop:disable ClassLength, Metrics/MethodLength
class StaffRequestsController < ApplicationController
  include PersonnelRequestController
  before_action :set_staff_request, only: [:show, :edit, :update, :destroy]
  after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  # GET /staff_requests
  # GET /staff_requests.json
  def index
    @q = StaffRequest.ransack(params[:q])

    default_sorts!
    include_associations!(%i( division department employee_type request_type unit ))
    @staff_requests = scope_records(params)

    respond_to do |format|
      format.html
      format.xlsx { send_xlsx(@staff_requests, StaffRequest) }
    end
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
    assign_selectable_departments_and_units(@staff_request)
  end

  # GET /staff_requests/1/edit
  def edit
    authorize @staff_request
    assign_selectable_departments_and_units(@staff_request)
  end

  # POST /staff_requests
  # POST /staff_requests.json
  def create
    @staff_request = StaffRequest.new(staff_request_params)
    authorize @staff_request

    respond_to do |format|
      if @staff_request.save
        format.html do
          redirect_to @staff_request,
                      notice: "Staff request for #{@staff_request.description} was successfully created."
        end
        format.json { render :show, status: :created, location: @staff_request }
      else
        format.html do
          assign_selectable_departments_and_units(@staff_request)
          render :new
        end
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
        format.html do
          redirect_to @staff_request,
                      notice: "Staff request for #{@staff_request.description} was successfully updated."
        end
        format.json { render :show, status: :ok, location: @staff_request }
      else
        format.html do
          assign_selectable_departments_and_units(@staff_request)
          render :new
        end
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
      format.html do
        redirect_to staff_requests_url,
                    notice: "Staff request for #{@staff_request.description} was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

    # called when there's a policy failure
    def not_authorized(exception)
      raise exception if exception.record.is_a? Class
      raise exception unless exception.record.new_record?
      # if we are making a new record, lets just reshow the form to let folks
      # try and fix and resubmit
      assign_selectable_departments_and_units(@staff_request)
      case exception
      when Pundit::NotAuthorizedDepartmentError
        @staff_request.errors.add(:department_id,
                                  "You are not allowed to make departmental requests to department: #{@staff_request.department.name}")
      when Pundit::NotAuthorizedUnitError
        @staff_request.errors.add(:unit_id,
                                  "You are not allowed to make requests to unit #{@staff_request.unit.name}")

      end
      render :edit
    rescue Pundit::NotAuthorizedError => e
      flash[:error] = "Access Denied -- #{e.message}"
      redirect_to root_url
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_staff_request
      @staff_request = StaffRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_request_params
      allowed = [:employee_type_id, :position_title, :request_type_id,
                 :annual_base_pay, :nonop_funds, :nonop_source, :department_id,
                 :unit_id, :justification] + policy(@staff_request || StaffRequest.new).permitted_attributes
      params.require(:staff_request).permit(allowed)
    end
end
