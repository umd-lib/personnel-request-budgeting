class ImpersonateController < ApplicationController
  after_action :verify_authorized

  # Session parameter name for impersonation id
  IMPERSONATE_USER_PARAM = 'impersonate_user_id'.freeze

  # GET /impersonate
  def index
    authorize :impersonate
    @q = User.ransack(params[:q])
    @q.sorts = 'cas_directory_id' if @q.sorts.empty?
    @users = @q.result
  end

  # GET /impersonate/user/123
  def create
    authorize :impersonate
    impersonated_user = User.find_by(id: params[:user_id])
    impersonate(impersonated_user)
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
    # +impersonated_user+: the user to impersonate
    def impersonate(impersonated_user)
      unless impersonated_user.nil?
        logout
        session[IMPERSONATE_USER_PARAM] = impersonated_user.id
        logger.info "#{actual_user.cas_directory_id} now impersonating #{current_user.cas_directory_id}"
      end
    end

    # Stops impersonation
    def revert_impersonate
      unless session[IMPERSONATE_USER_PARAM].nil?
        logout
        impersonated_user = current_user
        session[IMPERSONATE_USER_PARAM] = nil
        logger.info "#{actual_user.cas_directory_id} has stopped impersonating #{impersonated_user.cas_directory_id}"
      end
    end
end
