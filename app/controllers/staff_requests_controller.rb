class StaffRequestsController < ApplicationController
  include PersonnelRequestController

  private

    def model_klass
      StaffRequest
    end

    alias allowed_defaults allowed
    def allowed
      allowed_defaults + %i[annual_base_pay employee_name]
    end
end
