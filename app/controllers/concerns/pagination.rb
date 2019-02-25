module Pagination
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20

  def options(collection)
    total_pages_size = total_pages(collection)
    hash = {
      links: {},
      meta: {
        current_page: current_page,
        total_pages: total_pages_size,
        total_records: collection.size
      }
    }

    if current_page > 1
      hash[:links][:first] = generate_url(1)
      hash[:links][:prev] = generate_url(current_page - 1)
    end

    hash[:links][:self] = generate_url(current_page)

    if current_page < total_pages_size
      hash[:links][:next] = generate_url(current_page + 1)
      hash[:links][:last] = generate_url(total_pages_size)
    end
    hash
  end

  private

  def generate_url(page)
    url = request.base_url + request.path
    [url, url_params(page)].join('?')
  end

  def url_params(page)
    url_params = {}
    url_params[:per_page] = per_page if include_per_page?
    url_params[:page] = page if include_page?(page)
    url_params.to_query
  end

  def current_page
    (params[:page] || 1).to_i
  end
  
  def per_page
    (params[:per_page] || 20).to_i
  end

  def total_pages(collection)
    ((collection.size.to_f / per_page.to_f).ceil || 1).ceil.to_i
  end

  def include_per_page?
    (per_page != 0) && (per_page != DEFAULT_PER_PAGE)
  end

  def include_page?(page)
    (page != 0) && (page != DEFAULT_PAGE)
  end
end
