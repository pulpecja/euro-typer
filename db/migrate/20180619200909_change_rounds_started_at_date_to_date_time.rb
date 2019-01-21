class ChangeRoundsStartedAtDateToDateTime < ActiveRecord::Migration[5.2]
  def change
    change_column :rounds, :started_at, :datetime
  end
end
