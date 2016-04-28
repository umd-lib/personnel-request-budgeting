json.array!(@units) do |unit|
  json.extract! unit, :id, :code, :name, :department_id
  json.url unit_url(unit, format: :json)
end
