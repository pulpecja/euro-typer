json.array!(@matches) do |match|
  json.extract! match, :id, :first_team_id, :second_team_id, :date
  json.url match_url(match, format: :json)
end
