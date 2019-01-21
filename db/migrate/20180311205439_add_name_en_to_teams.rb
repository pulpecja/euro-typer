class AddNameEnToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :name_en, :string
    change_column :teams, :name, :string, :null => true
  end
end
