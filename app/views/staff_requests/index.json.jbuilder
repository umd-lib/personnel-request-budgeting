json.array!(@staff_requests) do |staff_request|
  json.extract! staff_request, :id, :employee_type_id, :position_description,
                :request_type_id, :annual_base_pay, :nonop_funds,
                :nonop_source, :department_id, :subdepartment_id,
                :justification
  json.url staff_request_url(staff_request, format: :json)
end
