class CompetitionsUser < ActiveRecord::Base
  belongs_to :competition
  belongs_to :user
end
