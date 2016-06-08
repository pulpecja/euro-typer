class Match < ActiveRecord::Base
  include Bettable

  belongs_to :first_team,  class_name: "Team"
  belongs_to :second_team, class_name: "Team"
  belongs_to :round

  has_many :types, dependent: :destroy

  validates_presence_of :first_team, :second_team, :played, :round_id
  validates :first_score, :second_score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validate :check_teams

  scope :by_round, ->(round) { where(round_id: round.id) }
  scope :by_team , ->(team)  { where('first_team_id = ? OR second_team_id = ?', team.id, team.id) }
  default_scope              { order('played') }

  private
  def check_teams
    if first_team == second_team
      errors[:add] << "You can't choose the same teams"
    end
  end
end
