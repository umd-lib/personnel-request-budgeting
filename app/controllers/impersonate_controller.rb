class ImpersonateController < ApplicationController
  after_action :verify_authorized

  # Session parameter name for impersonation id
  IMPERSONATE_USER_PARAM = 'impersonate_user_id'.freeze

  # GET /impersonate
  def index
    authorize :impersonate
    @users = User.all
    @q = User.ransack(params[:q])
    @q.sorts = 'cas_directory_id' if @q.sorts.empty?
    @users = @q.result
  end

  # GET /impersonate/user/123
  def create
    authorize :impersonate
    @impersonated_user = User.find_by(id: params[:user_id])
    impersonate(@impersonated_user)
    redirect_to root_path
  end

  # Revert the user impersonation
  # DELETE /impersonate/revert
  def destroy
    authorize :impersonate
    revert_impersonate
    redirect_to root_path
  end

  private

    # Sets session parameter for performing impersonations
    #
    # +new_user+: the user to impersonate
    def impersonate(new_user)
      session[IMPERSONATE_USER_PARAM] = new_user.id
    end

    # Stops impersonation
    def revert_impersonate
      session[IMPERSONATE_USER_PARAM] = nil
    end
end
