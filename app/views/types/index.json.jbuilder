json.array!(@types) do |type|
  json.extract! type, :id, :user_id, :match_id, :first_score, :second_score
  json.url type_url(type, format: :json)
end
