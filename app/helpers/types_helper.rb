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

  def inplace_editable(data)
    { class: 'editable',
      data: {
        name:       data[:name],
        type:       data[:type],
        resource:   data[:resource],
        url:        data[:url],
        source:     data[:source],
        value:      data[:value],
        display:    data[:display],
        mode:       data[:mode],
        httpMethod: data[:httpMethod]
      }
    }
  end
end
