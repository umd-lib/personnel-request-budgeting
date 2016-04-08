json.array!(@contractor_requests) do |contractor_request|
  json.extract! contractor_request, :id, :employee_type_id,
                :position_description, :request_type_id, :contractor_name,
                :number_of_months, :annual_base_pay, :nonop_funds,
                :nonop_source, :department_id, :subdepartment_id, :justification
  json.url contractor_request_url(contractor_request, format: :json)
end
