module TypesHelper
  def type_match(match)
    "#{match.first_team.name} - #{match.second_team.name}"
  end

  def type_score(type)
    "#{type.first_score.to_s} - #{type.second_score.to_s}"
  end

  def type_link(type)
    if type.present?
      type_score(type)
    else
      "typuj ziom"
    end
  end
end
