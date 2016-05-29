module MatchesHelper
  def played_value(match)
    (match.played || Time.now).strftime("%d.%m.%Y, %H:%M")
  end
end
