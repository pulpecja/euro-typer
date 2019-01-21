class CreateCompetitionsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :competitions_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :competition, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
