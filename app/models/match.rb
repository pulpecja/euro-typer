class Match < ActiveRecord::Base
  include Bettable

  belongs_to :first_team,  class_name: "Team"
  belongs_to :second_team, class_name: "Team"
  belongs_to :round

  has_many :types

  validates_presence_of :first_team, :second_team, :played
  validate :check_teams

  scope :by_round, ->(round) { where(round_id: round.id) }

  private
  def check_teams
    if first_team == second_team
      errors[:add] << "You can't choose the same teams"
    end
  end
end
