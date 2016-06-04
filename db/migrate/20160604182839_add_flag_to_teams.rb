class AddFlagToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :flag, :string
  end
end
