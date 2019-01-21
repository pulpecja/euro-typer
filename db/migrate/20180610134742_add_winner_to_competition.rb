class AddWinnerToCompetition < ActiveRecord::Migration[5.2]
  def change
    add_reference :competitions, :winner, index: true
  end
end
