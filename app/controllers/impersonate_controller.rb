class ImpersonateController < ApplicationController
  after_action :verify_authorized

  # Session parameter name for impersonation id
  IMPERSONATE_USER_PARAM = 'impersonate_user_id'.freeze

  # GET /impersonate
  def index
    authorize :impersonate
    @q = User.ransack(params[:q])
    @q.sorts = 'cas_directory_id' if @q.sorts.empty?
    # Map users to ImpersonatedUser so view knows which policy to use
    @users = @q.result.includes(:role_types, :roles).map { |u| ImpersonatedUser.new(u) }
  end

  # GET /impersonate/user/123
  def create
    impersonated_user = User.find_by(id: params[:user_id])
    authorize ImpersonatedUser.new(impersonated_user)
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

    # Delegate class for User, which specifies that the ImpersonatePolicy should
    # be used
    class ImpersonatedUser < DelegateClass(User)
      delegate :id, to: :__getobj__
      def policy_class
        ImpersonatePolicy
      end
    end

    # Sets session parameter for performing impersonations
    #
    # +impersonated_user+: the user to impersonate
    def impersonate(impersonated_user)
      return if impersonated_user.nil?
      clear_current_user # just a sanity check
      session[IMPERSONATE_USER_PARAM] = impersonated_user.id
      logger.info "#{actual_user.cas_directory_id} now impersonating #{current_user.cas_directory_id}"
    end

    # Stops impersonation
    def revert_impersonate
      return if session[IMPERSONATE_USER_PARAM].nil?
      clear_current_user
      impersonated_user = current_user
      session[IMPERSONATE_USER_PARAM] = nil
      logger.info "#{actual_user.cas_directory_id} has stopped impersonating #{impersonated_user.cas_directory_id}"
    end
end
