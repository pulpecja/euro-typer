class ChangeRoundsStartedAtDateToDateTime < ActiveRecord::Migration
  def change
    change_column :rounds, :started_at, :datetime
  end
end
