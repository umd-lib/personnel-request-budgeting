json.array!(@labor_requests) do |labor_request|
  json.extract! labor_request, :id, :employee_type_id, :position_description,
                :request_type_id, :contractor_name, :num_of_positions,
                :hourly_rate, :hours_per_week, :number_of_weeks, :nonop_funds,
                :nonop_source, :department_id, :subdepartment_id, :justification
  json.url labor_request_url(labor_request, format: :json)
end
