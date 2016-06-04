module MatchesHelper
  def played_value(match)
    (match.played || Time.now).strftime("%d.%m.%Y, %H:%M")
  end

  def match_link(adjective, round_id)
    link_to "#{adjective} kolejka", matches_path(round: round_id) if Round.where(id: round_id).present?
  end

end
