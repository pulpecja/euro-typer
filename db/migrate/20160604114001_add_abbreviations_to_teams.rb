class AddAbbreviationsToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :abbreviation, :string
  end
end
