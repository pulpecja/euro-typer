class AddCompetitionIdToRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :rounds, :competition_id, :integer
  end
end
