class AddIndexes < ActiveRecord::Migration
  def change
    add_index :types, :user_id
    add_index :types, :match_id
    add_index :rounds, :competition_id
    add_index :matches, :first_team_id
    add_index :matches, :second_team_id
    add_index :matches, :round_id
    add_index :groups, :owner_id
  end
end
