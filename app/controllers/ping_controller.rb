
class PingController < ApplicationController
  skip_before_action :authenticate
  skip_after_action :verify_authorized
  def verify
    if ActiveRecord::Base.connected?
      render text: 'Application is OK'
    else
      render text: 'Cannot connect to database!', status: :service_unavailable
    end
  end
end
