class Competition < ActiveRecord::Base
  has_many :rounds
  has_many :competitions_groups, dependent: :destroy
  has_many :groups, -> { distinct }, through: :competitions_groups

  validates_presence_of :name

  scope :finished, -> { where('end_date < ?', Time.now) }
  scope :lasting,  -> { where('end_date > ?', Time.now).where('start_date < ?', Time.now) }
  scope :upcoming, -> { where('start_date > ?',  Time.now) }

  def first_round
    rounds.find_by(stage: 1)
  end

  def last_round
    rounds.order(:stage).last
  end

end
