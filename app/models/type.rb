class Type < ActiveRecord::Base
  belongs_to :match
  belongs_to :user

  validate :check_scores

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
end
