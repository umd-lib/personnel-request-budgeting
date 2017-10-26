# Controller for Icinga network monitoring to use to determine whether the
# application is running.
class PingController < ApplicationController
  # Controller actions should be accessible without requiring authenication.
  skip_before_action :ensure_auth

  def verify
    if ActiveRecord::Base.connected?
      render text: 'Application is OK'
    else
      render text: 'Cannot connect to database!', status: :service_unavailable
    end
  end
end
