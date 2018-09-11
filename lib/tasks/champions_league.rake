namespace :competitions do
  desc "Add Euro 2016 competition"
  task :add_champions_league => :environment do
    include FootballDataApiLogic

    champions_league = Competition.find_or_create_by(name: 'Champions League',
                                                     year: 2018,
                                                     place: 'Europe',
                                                     start_date: '18.09.2018'.to_datetime)

    teams = fetch_data('v2/competitions/2001/teams')['teams']
    teams.each do |team|
      Team.find_or_create_by(name: team['name'],
                             abbreviation: team['tla'],
                             flag: team['crestUrl'],
                             name_en: team['name'])
    end

    matches = fetch_data('v2/competitions/2001/matches?status=SCHEDULED')['matches']

    matches.each do |match|

      round = Round.find_or_create_by(name: "Kolejka #{match['matchday']}", competition_id: champions_league.id, stage: match['matchday'])
      round.started_at = match['utcDate'].to_date if round.started_at == '20.06.2016'
      round.save

      first_team = Team.find_by(name_en: match['homeTeam']['name'])
      second_team = Team.find_by(name_en: match['awayTeam']['name'])
      played_time = match['utcDate'].to_datetime + 2.hours

      Match.find_or_create_by(first_team: first_team, second_team: second_team, round: round, played: played_time)

    end
  end
end