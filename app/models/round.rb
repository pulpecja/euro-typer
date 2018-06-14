class Round < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  belongs_to :competition

  validates_presence_of :started_at

  scope :scheduled, -> { where('started_at >= ?', Time.now ) }
  scope :started,   -> { where('started_at < ?',  Time.now ) }

  default_scope { order('started_at') }

  def next_round
    competition.rounds.find_by(stage: stage + 1)&.id
  end

  def previous_round
    competition.rounds.find_by(stage: stage - 1)&.id
  end

  def start_date
    matches.map(&:played).min
  end

  def end_date
    matches.map(&:played).max
  end
end
