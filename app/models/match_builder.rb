class MatchBuilder
  def initialize
    @match = Match.new
  end

  def set_competition(name, year, place, start_date)
    @competition = Competition.find_or_create_by(name: 'Champions League',
                                                 year: 2018,
                                                 place: 'Europe',
                                                 start_date: '18.09.2018'.to_datetime)
  end

  def set_round(stage, started_at)
    @match.round = Round.find_or_create_by(name: "Kolejka #{stage}",
                                           competition_id: @competition.id,
                                           stage: stage)
    @match.round.started_at ||= started_at
    @match.round.save
  end

  def set_first_team(team)
    @match.first_team = Team.find_or_create_by(name: team['name'],
                                               abbreviation: team['abbr'],
                                               flag: team['flag'],
                                               name_en: team['name'])
  end

  def set_second_team(team)
    @match.second_team = Team.find_or_create_by(name: team['name'],
                                                abbreviation: team['abbr'],
                                                flag: team['flag'],
                                                name_en: team['name'])
  end

  def set_played_time(date)
    @match.played = date
  end

  def match
    obj = @match.dup
    @match = Match.new
    return obj
  end
end