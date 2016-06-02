json.array!(@rounds) do |round|
  json.extract! round, :id, :name
  json.url round_url(round, format: :json)
end
