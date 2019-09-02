namespace :competitions do
  desc "Add Euro 2016 competition"
  task add_champions_league_2020: :environment do
    include FootballDataApiLogic

    champions_league = Competition.find_or_create_by(name: 'Champions League 2019/20',
                                                     year: 2020,
                                                     place: 'Europe')

    competitions = fetch_data('v2/competitions')['competitions']
    api_champions_league = competitions.select {|comp| comp['name'] == 'UEFA Champions League'}

    teams = fetch_data('v2/competitions/2001/teams')['teams']
    teams.each do |team|
      new_team = Team.find_or_create_by(abbreviation: team['tla'],
                                        flag: team['crestUrl'],
                                        name_en: team['name'])

      new_team.name ||= new_team.name_en
      new_team.save
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

    todays_teams = Team.where('created_at >= ?', '02-09-2019'.to_datetime)
    todays_teams.each do |team|
      next if team.first_team.present? || team.second_team.present?
      team.destroy
    end
  end
end
