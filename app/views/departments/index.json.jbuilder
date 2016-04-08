json.array!(@departments) do |department|
  json.extract! department, :id, :code, :name, :division_id
  json.url department_url(department, format: :json)
end
