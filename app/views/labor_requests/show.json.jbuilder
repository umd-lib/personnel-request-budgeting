json.extract! @labor_request, :id, :employee_type_id, :position_description,
              :request_type_id, :contractor_name, :number_of_positions,
              :hourly_rate, :hours_per_week, :number_of_weeks, :nonop_funds,
              :nonop_source, :department_id, :unit_id, :justification,
              :created_at, :updated_at, :review_status_id, :review_comment
