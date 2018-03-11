class AddCompetitionIdToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :competition_id, :integer
  end
end
