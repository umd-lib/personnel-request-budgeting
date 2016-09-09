json.array!(@role_cutoffs) do |role_cutoff|
  json.extract! role_cutoff, :id, :role_type_id, :cutoff_date
  json.url role_cutoff_url(role_cutoff, format: :json)
end
