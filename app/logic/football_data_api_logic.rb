module FootballDataApiLogic
  def connect
    @connection ||= Faraday.new(url: 'http://api.football-data.org',
                                headers: {"X-Auth-Token" => ENV['FOOTBALL_DATA_API_KEY']})

  end

  def fetch_data(api_endpoint)
    connect
    response = @connection.get api_endpoint
    JSON.parse(response.body)
  end
end
