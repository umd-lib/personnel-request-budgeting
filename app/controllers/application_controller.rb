class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include CasHelper
  include Pundit

  before_action :fix_cas_session
  before_action :ensure_auth
  before_action :load_links

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  def not_authorized
    render(file: Rails.root.join('public', '403.html'), status: :forbidden, layout: false)
  end

  def load_links
    @links = Link.all
  end
end
