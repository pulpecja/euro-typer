class AddStageToRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :rounds, :stage, :integer
  end
end
