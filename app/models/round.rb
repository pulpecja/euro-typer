class Round < ActiveRecord::Base
  has_and_belongs_to_many :matches
end
