class WinnerType < ActiveRecord::Base

  belongs_to :competition
  belongs_to :user
  belongs_to :team

  validates_presence_of :team, :user, :competition

end