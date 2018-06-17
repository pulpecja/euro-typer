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

  def user_groups(user)
    return Group.all if current_user.is_admin?
    user.groups
  end

end
