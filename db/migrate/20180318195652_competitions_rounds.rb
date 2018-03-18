class CompetitionsRounds < ActiveRecord::Migration
  def change
    create_table :competitions_groups do |t|
      t.references :competition, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
