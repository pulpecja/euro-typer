module Bettable

  extend ActiveSupport::Concern

  included do
    before_update :set_bet
  end

  def set_bet
    if first_score.present? && second_score.present?
      bet_type = case
      when first_score > second_score
        '1'
      when first_score < second_score
        '2'
      else
        'x'
      end
    end
    self.update_column(:bet, bet_type)
  end

end