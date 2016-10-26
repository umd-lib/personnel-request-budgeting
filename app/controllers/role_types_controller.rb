class RoleTypesController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  before_action :set_role_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /role_types
  # GET /role_types.json
  def index
    authorize RoleType
    @q = RoleType.ransack(params[:q])
    @q.sorts = 'code' if @q.sorts.empty?
    @role_types = @q.result
  end

  # GET /role_types/1
  # GET /role_types/1.json
  def show
    authorize RoleType
  end

  # GET /role_types/new
  def new
    authorize RoleType
    @role_type = RoleType.new
  end

  # GET /role_types/1/edit
  def edit
    authorize RoleType
  end

  # POST /role_types
  # POST /role_types.json
  def create
    authorize RoleType
    @role_type = RoleType.new(role_type_params)

    respond_to do |format|
      if @role_type.save
        format.html { redirect_to @role_type, notice: "Role type #{@role_type.description} was successfully created." }
        format.json { render :show, status: :created, location: @role_type }
      else
        format.html { render :new }
        format.json { render json: @role_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /role_types/1
  # PATCH/PUT /role_types/1.json
  def update
    authorize RoleType
    respond_to do |format|
      if @role_type.update(role_type_params)
        format.html { redirect_to @role_type, notice: "Role type #{@role_type.description} was successfully updated." }
        format.json { render :show, status: :ok, location: @role_type }
      else
        format.html { render :edit }
        format.json { render json: @role_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /role_types/1
  # DELETE /role_types/1.json
  def destroy
    authorize RoleType
    respond_to do |format|
      if delete
        format.html { redirect_to role_types_url, notice: "Role type #{@role_type.description} was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to role_types_url, flash: { error: @error_msg } }
        format.json { render json: [error], status: :unprocessable_entity }
      end
    end
  end

  private

    # Returns true if the current role type was deleted. If the role type
    # cannot be deleted due an ActiveRecord::DeleteRestrictionError, populates
    # @error_msg and returns false.
    def delete
      @role_type.destroy
      return true
    rescue ActiveRecord::DeleteRestrictionError
      @error_msg = 'Role type cannot be removed as it is used by other records.'
      return false
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_role_type
      @role_type = RoleType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_type_params
      params.require(:role_type).permit(:code, :name)
    end
end
