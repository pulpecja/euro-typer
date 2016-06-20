class Round < ActiveRecord::Base
  has_many :matches

  validates_presence_of :started_at

  default_scope { order('started_at') }
end
