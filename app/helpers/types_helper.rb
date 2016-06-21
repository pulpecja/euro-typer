module TypesHelper
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

  def round_link(adjective, round_id)
    link_to "#{adjective} kolejka", round_types_path(round_id) if Round.where(id: round_id).present?
  end

  def can_be_typed?(played)
    played.in_time_zone > (DateTime.now.in_time_zone + 110.minutes)
  end

  def type_hidden?(match, user)
    can_be_typed?(match.played) && user != current_user
  end

  def good_bet(match, type)
    if match.bet.present? && type.try(:bet).present?
      match.bet == type.bet
    end
  end

  def good_type(match, type)
    if match.first_score.present? && match.second_score.present? && type.try(:first_score).present? && type.try(:second_score).present?
      match.first_score == type.first_score && match.second_score == type.second_score
    end
  end
end
