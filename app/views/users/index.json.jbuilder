json.array!(@users) do |user|
  json.extract! user, :id, :account_name, :full_name, :password, :email, :administrator
  json.url user_url(user, format: :json)
end
