class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.integer :first_team_id, null: false
      t.integer :second_team_id, null: false
      t.timestamp :played, null: false

      t.timestamps
    end
  end
end
