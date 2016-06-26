class Type < ActiveRecord::Base
  include Bettable

  belongs_to :match
  belongs_to :user

  validate :check_scores
  validate :check_date, on: :update

  scope :by_user, ->(current_user) { where(user_id: current_user.id) }

  private
  def check_scores
    [first_score, second_score].each do |score|
      if score.present? && !score.is_a?(Integer)
        errors[:add] << "nie jest liczbą"
      elsif score.present? && score < 0
        errors[:add] << "nie może być mniejsze od 0"
      end
    end
  end

  def check_date
    unless match.played.in_time_zone > (DateTime.now.in_time_zone + 130.minutes)
      errors[:add] << "za późno na typowanie tego meczu"
    end
  end

end
