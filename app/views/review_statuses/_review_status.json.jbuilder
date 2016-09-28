json.extract! review_status, :id, :code, :name, :color, :created_at, :updated_at
json.url review_status_url(review_status, format: :json)
