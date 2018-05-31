module MatchesHelper
  def played_value(match)
    proper_date(match.played || Time.now)
  end

  def proper_date(date)
    date.strftime("%d.%m.%Y, %H:%M")
  end

  def match_link(adjective, round_id)
    return unless round_id.present?
    link_to "#{adjective} kolejka", link_url(round_id)
  end

  def link_url(round_id)
    if @group.nil?
      competition_path(@round.competition, round: round_id)
    else
      group_competition_matches_path(@group.id,
                                     @round.competition.id,
                                     round: round_id)
    end
  end

end
