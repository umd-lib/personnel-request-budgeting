json.array!(@subdepartments) do |subdepartment|
  json.extract! subdepartment, :id, :code, :name, :department_id
  json.url subdepartment_url(subdepartment, format: :json)
end
