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
end
