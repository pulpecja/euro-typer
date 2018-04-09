class AddStageToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :stage, :integer
  end
end
