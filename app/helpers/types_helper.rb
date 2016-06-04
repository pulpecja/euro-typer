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
    played.in_time_zone > (DateTime.now.in_time_zone + 4.hours)
  end
end
