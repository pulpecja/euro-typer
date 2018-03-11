class AddNameEnToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :name_en, :string
    change_column :teams, :name, :string, :null => true
  end
end
