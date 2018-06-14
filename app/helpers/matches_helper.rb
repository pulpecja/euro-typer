module MatchesHelper
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

  def can_type_winner?(competition)
    DateTime.now < (competition.start_date)
  end

end
