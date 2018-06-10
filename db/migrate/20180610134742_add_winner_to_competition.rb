class AddWinnerToCompetition < ActiveRecord::Migration
  def change
    add_reference :competitions, :winner, index: true
  end
end
