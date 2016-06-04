class AddAbbreviationsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :abbreviation, :string
  end
end
