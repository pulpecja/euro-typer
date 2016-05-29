class Team < ActiveRecord::Base
  has_many :matches

  scope :ordered, -> { order :name }
end
