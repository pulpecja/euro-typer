json.array!(@competitions) do |competition|
  json.extract! competition, :id, :name, :year, :place
  json.url competition_url(competition, format: :json)
end
