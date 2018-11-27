namespace :competitions do
  desc 'Add new competition with builder'
  task add_test_competition: :environment do
    include FootballDataApiLogic

    matches = fetch_data('v2/competitions/2001/matches')['matches']
    builder = MatchBuilder.new

    matches.each do |match|
      builder.set_competition('Champions League', 2018, 'Europe', '18.09.2018'.to_datetime)
      builder.set_round(match['matchday'], match['utcDate'].to_date)
      builder.set_first_team(match['homeTeam'])
      builder.set_second_team(match['awayTeam'])
      builder.set_played_time(match['utcDate'].to_datetime + 2.hours)
      builder.match.save
    end
  end
end

