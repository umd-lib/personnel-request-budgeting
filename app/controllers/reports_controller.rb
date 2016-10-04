class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy, :download]
  after_action :verify_authorized, only: [:index, :show, :create, :destroy, :download]

  # GET /reports
  # GET /reports.json
  def index
    authorize Report
    @q = Report.ransack(params[:q])
    @reports = @q.result.page(params[:page])
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    authorize Report
  end

  # GET /reports/new
  def new
    authorize Report
    @report = Report.new(creator: current_user)
  end

  # GET /reports/1/edit
  def edit
    redirect_to @report
  end

  # POST /reports
  # POST /reports.json
  def create # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    authorize Report
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        ReportJob.perform_later @report
        format.html { redirect_to @report, notice: 'Request type was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    render text: 'Not Found', status: '404'
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    authorize Report
    respond_to do |format|
      if delete
        format.html { redirect_to reports_url, notice: 'Request type was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to reports_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  def download
    authorize Report
    respond_to do |format|
      format.xlsx do
        send_data @report.output,
                  filename: "#{@report.name}_#{@report.created_at.strftime('%Y%m%d%H%M%S')}.xlsx",
                  disposition: 'attachment'
      end
    end
  end

  private

    # Returns true if the current request type was deleted. If the request type
    # cannot be deleted due an ActiveRecord::DeleteRestrictionError, populates
    # @error_msg and returns false.
    def delete
      @report.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Request type cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:name, :format, :user_id, :user_id, :parameters)
    end
end
