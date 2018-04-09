class Competition < ActiveRecord::Base
  has_many :rounds
  has_many :competitions_groups, dependent: :destroy
  has_many :groups, -> { distinct }, through: :competitions_groups
end
