class RequestTypesController < ApplicationController
  before_action :set_request_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /request_types
  # GET /request_types.json
  def index
    authorize RequestType
    @q = RequestType.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @request_types = @q.result
  end

  # GET /request_types/1
  # GET /request_types/1.json
  def show
    authorize RequestType
  end

  # GET /request_types/new
  def new
    authorize RequestType
    @request_type = RequestType.new
  end

  # GET /request_types/1/edit
  def edit
    authorize RequestType
  end

  # POST /request_types
  # POST /request_types.json
  # rubocop:disable Metrics/MethodLength
  def create
    authorize RequestType
    @request_type = RequestType.new(request_type_params)

    respond_to do |format|
      if @request_type.save
        format.html { redirect_to @request_type, notice: 'Request type was successfully created.' }
        format.json { render :show, status: :created, location: @request_type }
      else
        format.html { render :new }
        format.json { render json: @request_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /request_types/1
  # PATCH/PUT /request_types/1.json
  def update
    authorize RequestType
    respond_to do |format|
      if @request_type.update(request_type_params)
        format.html { redirect_to @request_type, notice: 'Request type was successfully updated.' }
        format.json { render :show, status: :ok, location: @request_type }
      else
        format.html { render :edit }
        format.json { render json: @request_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /request_types/1
  # DELETE /request_types/1.json
  def destroy
    authorize RequestType
    respond_to do |format|
      if delete
        format.html { redirect_to request_types_url, notice: 'Request type was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to request_types_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current request type was deleted. If the request type
    # cannot be deleted due an ActiveRecord::DeleteRestrictionError, populates
    # @error_msg and returns false.
    def delete
      @request_type.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Request type cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_request_type
      @request_type = RequestType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_type_params
      params.require(:request_type).permit(:code, :name)
    end
end
