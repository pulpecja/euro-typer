class ChangeFirstGoalsToFirstScore < ActiveRecord::Migration
  def change
    rename_column :matches, :first_goals, :first_score
    rename_column :matches, :second_goals, :second_score
  end
end
