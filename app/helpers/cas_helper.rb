module CasHelper
  attr_reader :current_user

  def authenticate
    CASClient::Frameworks::Rails::Filter.before(self)

    if session[:cas_user] && !allow_access
      render(file: File.join(Rails.root, 'public/403.html'), status: :forbidden, layout: false)
    end
  end

  # Retrieves the User for the current request from the database, using the
  # "cas_user" id from the session, or nil if the User cannot be found.
  def current_user
    User.find_by_cas_directory_id(session[:cas_user])
  end

  private

    # Returns true if entry is authorized, false otherwise.
    def allow_access
      !current_user.nil?
    end
end
