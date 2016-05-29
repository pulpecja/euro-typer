class Match < ActiveRecord::Base
  belongs_to :first_team,  class_name: "Team"
  belongs_to :second_team, class_name: "Team"

  has_many :types

  validates_presence_of :first_team, :second_team, :played
  validate :check_teams

  private
  def check_teams
    if first_team == second_team
      errors[:add] << "You can't choose the same teams"
    end
  end
end
