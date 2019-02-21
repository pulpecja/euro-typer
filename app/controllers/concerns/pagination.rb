module Pagination
  def options
    { links: {
        first: admin_teams_path(per_page: per_page),
        self: admin_teams_path(page: current_page, per_page: per_page),
        last: admin_teams_path(page: total_pages, per_page: per_page)
      }
    }
  end

  private
  def current_page
    (params[:page] || 1).to_i
  end
  
  def per_page
    (params[:per_page] || 20).to_i
  end

  def total_pages
    ((@teams.size.to_f / per_page.to_f).ceil || 1).ceil.to_i
  end
end
