class CompetitionsGroup < ApplicationRecord
  belongs_to :competition
  belongs_to :group
end
