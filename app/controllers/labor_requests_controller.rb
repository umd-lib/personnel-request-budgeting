# frozen_string_literal: true

class LaborRequestsController < ApplicationController
  include PersonnelRequestController

  private

    def model_klass
      LaborRequest
    end

    alias allowed_defaults allowed
    def allowed
      allowed_defaults + %i[ contractor_name number_of_positions hourly_rate
                             hours_per_week number_of_weeks]
    end
end
