json.array!(@employee_types) do |employee_type|
  json.extract! employee_type, :id, :code, :name, :employee_category_id
  json.url employee_type_url(employee_type, format: :json)
end
