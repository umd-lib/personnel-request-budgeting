# Provides CAS Authentication and whitelist authorization
module CasHelper
  attr_reader :current_user

  # Uses CAS to authenticate users, and provide white-list authorization
  def authenticate
    CASClient::Frameworks::Rails::Filter.before(self)

    if session[:cas_user] && !allow_access
      render(file: File.join(Rails.root, 'public/403.html'), status: :forbidden, layout: false)
    end
  end

  # Returns true if a user is being impersonated, false otherwise
  def impersonating_user?
    !session[ImpersonateController::IMPERSONATE_USER_PARAM].nil?
  end

  # Returns the impersonated user
  def impersonated_user
    User.find_by(id: session[ImpersonateController::IMPERSONATE_USER_PARAM]) if impersonating_user?
  end

  # Returns the actual logged in user, ignoring impersonation
  def actual_user
    user_id = session[:cas_user]
    User.find_by_cas_directory_id(user_id)
  end

  # Retrieves the User for the current request from the database, using the
  # "cas_user" id from the session, the impersonated user, or nil
  # if the User cannot be found.
  def current_user
    return impersonated_user if impersonating_user?

    actual_user
  end

  private

    # Returns true if entry is authorized, false otherwise.
    def allow_access
      !current_user.nil?
    end
end
