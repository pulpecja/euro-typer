module ApplicationHelper
  def header(text)
    content_for(:header) { text.to_s }
  end

  def played_value(date)
    proper_date(date || Time.now)
  end

  def proper_date(date)
    date.strftime("%d.%m.%Y, %H:%M")
  end

end
