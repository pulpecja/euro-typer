namespace :teams do
  desc "Add teams from Football Data"
  task :add_teams => :environment do
    include FootballDataApiLogic

    competition = Competition.find_or_create_by(name: 'Mistrzostwa Świata',
                                                year: 2018,
                                                place: 'Rosja')

    teams = fetch_data('v1/competitions/467/teams')['teams']
    teams.each do |api_team|
      country = ISO3166::Country.find_country_by_name(api_team['name'])
      polish_name = country.translations["pl"] if country

      team = Team.find_or_create_by(name_en: api_team['name'],
                                    name: polish_name,
                                    abbreviation: api_team['code'] || (country.ioc if country),
                                    flag: api_team['crestUrl'])

      if team.valid?
        puts "Team #{team.name_en} created!"
      else
        puts "Team #{team.name_en} not created - #{team.errors.full_messages}"
      end
    end

    matches = fetch_data('v1/competitions/467/fixtures')['fixtures']
    matches.each do |api_match|
      first_team = Team.find_by(name_en: api_match['homeTeamName'])
      second_team = Team.find_by(name_en: api_match['awayTeamName'])
      round = Round.find_or_create_by(name: "Kolejka #{api_match['matchday']}",
                                      stage: api_match['matchday'],
                                      competition: competition)
      match = Match.find_or_create_by(first_team: first_team,
                                      second_team: second_team,
                                      played: api_match['date'],
                                      round: round)
      if match.valid?
        puts "Match #{match.first_team} - #{match.second_team} created!"
      else
        puts "Match #{match.first_team} - #{match.second_team} not created - #{match.errors.full_messages}"
      end
    end
  end
end