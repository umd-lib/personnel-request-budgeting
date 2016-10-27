# Provides CAS Authentication and whitelist authorization
module CasHelper
  # Uses CAS to authenticate users, and provide white-list authorization
  def authenticate
    CASClient::Frameworks::Rails::Filter.before(self)
    update_current_user(User.eager_load(:roles, :role_types).find_by(cas_directory_id: session[:cas_user]))

    return unless session[:cas_user] && !allow_access
    render(file: File.join(Rails.root, 'public/403.html'), status: :forbidden, layout: false)
  end

  # Returns true if a user is being impersonated, false otherwise
  def impersonating_user?
    !session[ImpersonateController::IMPERSONATE_USER_PARAM].nil?
  end

  # Returns the impersonated user
  def impersonated_user
    if @current_user.nil? || session[ImpersonateController::IMPERSONATE_USER_PARAM] != @current_user.id
      user = User.eager_load(:roles, :role_types).find_by(id: session[ImpersonateController::IMPERSONATE_USER_PARAM])
      update_current_user(user)
    end
    @current_user
  end

  # Returns the actual logged in user, ignoring impersonation
  def actual_user
    if @current_user.nil? || session[:cas_user] != @current_user.cas_directory_id
      update_current_user(User.eager_load(:roles, :role_types).find_by(cas_directory_id: session[:cas_user]))
    end
    @current_user
  end

  # Retrieves the User for the current request from the database, using the
  # "cas_user" id from the session, the impersonated user, or nil
  # if the User cannot be found.
  def current_user
    impersonating_user? ? impersonated_user : actual_user
  end

  def clear_current_user
    update_current_user(nil)
  end

  private

    attr_writer :current_user

    # Returns true if entry is authorized, false otherwise.
    def allow_access
      !@current_user.nil?
    end

    # Simply updates the current user
    def update_current_user(user)
      return nil unless user.is_a?(User)
      @current_user = user
      @current_user
    end
end
