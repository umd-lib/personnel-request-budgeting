class ReviewStatusesController < ApplicationController
  before_action :set_review_status, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /review_statuses
  # GET /review_statuses.json
  def index
    authorize ReviewStatus
    @q = ReviewStatus.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @review_statuses = @q.result
  end

  # GET /review_statuses/1
  # GET /review_statuses/1.json
  def show
    authorize ReviewStatus
  end

  # GET /review_statuses/new
  def new
    authorize ReviewStatus
    @review_status = ReviewStatus.new
  end

  # GET /review_statuses/1/edit
  def edit
    authorize ReviewStatus
  end

  # POST /review_statuses
  # POST /review_statuses.json
  # rubocop:disable Metrics/MethodLength
  def create
    authorize ReviewStatus
    @review_status = ReviewStatus.new(review_status_params)

    respond_to do |format|
      if @review_status.save
        format.html { redirect_to @review_status, notice: "Review status #{@review_status.description} was successfully created." }
        format.json { render :show, status: :created, location: @review_status }
      else
        format.html { render :new }
        format.json { render json: @review_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /review_statuses/1
  # PATCH/PUT /review_statuses/1.json
  def update
    authorize ReviewStatus
    respond_to do |format|
      if @review_status.update(review_status_params)
        format.html { redirect_to @review_status, notice: "Review status #{@review_status.description} was successfully updated." }
        format.json { render :show, status: :ok, location: @review_status }
      else
        format.html { render :edit }
        format.json { render json: @review_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /review_statuses/1
  # DELETE /review_statuses/1.json
  def destroy
    authorize ReviewStatus
    respond_to do |format|
      if delete
        format.html { redirect_to review_statuses_url, notice: "Review status #{@review_status.description} was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to review_statuses_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current division was deleted. If the division
    # cannot be deleted due an ActiveRecord::DeleteRestrictionError, populates
    # @error_msg and returns false.
    def delete
      @review_status.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Review Status cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_review_status
      @review_status = ReviewStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_status_params
      params.require(:review_status).permit(:code, :name, :color)
    end
end
