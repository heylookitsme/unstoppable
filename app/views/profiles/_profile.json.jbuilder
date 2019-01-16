json.extract! profile, :id, :name, :surname, :contact, :created_at, :updated_at
json.url profile_url(profile, format: :json)
