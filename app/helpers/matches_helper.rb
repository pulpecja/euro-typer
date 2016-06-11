module MatchesHelper
  def played_value(match)
    proper_date(match.played || Time.now)
  end

  def proper_date(date)
    date.strftime("%d.%m.%Y, %H:%M")
  end

  def match_link(adjective, round_id)
    link_to "#{adjective} kolejka", matches_path(round: round_id) if Round.where(id: round_id).present?
  end

end
