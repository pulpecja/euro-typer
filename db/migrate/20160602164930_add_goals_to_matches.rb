class AddGoalsToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :first_goals, :integer
    add_column :matches, :second_goals, :integer
  end
end
