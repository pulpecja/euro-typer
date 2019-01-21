class CreateWinnerTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :winner_types do |t|
      t.references :team, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :competition, index: true, foreign_key: true
    end
  end
end
