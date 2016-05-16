json.array!(@users) do |user|
  json.extract! user, :id, :cas_directory_id, :name
  json.url user_url(user, format: :json)
end
