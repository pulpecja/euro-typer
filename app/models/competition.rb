class Competition < ActiveRecord::Base
  has_many :rounds
  has_many :competitions_groups, dependent: :destroy
  has_many :groups, -> { distinct }, through: :competitions_groups
  belongs_to :winner, class_name: 'Team'

  validates_presence_of :name

  scope :finished, -> { where('end_date < ?', Time.now) }
  scope :lasting,  -> { where('end_date > ?', Time.now).where('start_date < ?', Time.now) }
  scope :upcoming, -> { where('start_date > ?', Time.now) }

  def first_round
    rounds.find_by(stage: 1)
  end

  def last_round
    rounds.order(:stage).last
  end

  def full_name
    name + ' ' + year.to_s
  end

  def competition_teams
    first_round.matches.map(&:second_team) + first_round.matches.map(&:first_team)
  end

end
