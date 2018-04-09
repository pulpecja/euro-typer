class Round < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  belongs_to :competition

  validates_presence_of :started_at

  scope :scheduled, -> { where('started_at >= ?', DateTime.now) }
  scope :finished, -> { where('started_at < ?', DateTime.now) }

  default_scope { order('started_at') }

  def next_round
    competition.rounds.find_by(stage: stage + 1).try :id
  end

  def previous_round
    competition.rounds.find_by(stage: stage - 1).try :id
  end
end
