class WinnerType < ApplicationRecord
  belongs_to :competition
  belongs_to :user
  belongs_to :team

  scope :by_competition, ->(competition_id) { where(competition_id: competition_id) }

  validates_presence_of :team, :user, :competition
end
