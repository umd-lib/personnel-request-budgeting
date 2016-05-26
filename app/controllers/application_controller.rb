class ApplicationController < ActionController::Base
  include CasHelper
  include Pundit
  before_action :authenticate

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Display "forbidden" page for failed authorization checks.
  def user_not_authorized
    render(file: File.join(Rails.root, 'public/403.html'), status: :forbidden, layout: false)
  end
end
