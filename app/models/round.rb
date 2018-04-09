class Round < ActiveRecord::Base
  has_many :matches, dependent: :destroy
  belongs_to :competition

  validates_presence_of :started_at

  default_scope { order('started_at') }

  def next_round
    # binding.pry
  end
end
