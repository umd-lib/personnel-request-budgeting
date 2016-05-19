json.array!(@roles) do |role|
  json.extract! role, :id, :user_id, :role_type_id, :division_id, :department_id, :unit_id
  json.url role_url(role, format: :json)
end
