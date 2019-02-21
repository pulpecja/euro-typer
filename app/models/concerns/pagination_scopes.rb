module PaginationScopes
  extend ActiveSupport::Concern

  included do
    scope :page, ->(page, per_page) {
      page == 1 ? all : offset((page - 1) * per_page)
    }
    scope :per, ->(per_page) { limit(per_page) }
  end
end