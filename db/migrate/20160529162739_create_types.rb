class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.integer :user_id
      t.integer :match_id
      t.integer :first_score
      t.integer :second_score

      t.timestamps
    end
  end
end
