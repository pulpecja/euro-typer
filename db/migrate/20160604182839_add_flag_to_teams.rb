class AddFlagToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :flag, :string
  end
end
