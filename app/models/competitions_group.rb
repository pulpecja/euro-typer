class CompetitionsGroup < ActiveRecord::Base
  belongs_to :competition
  belongs_to :group
end
