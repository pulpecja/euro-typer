class AddStartedAtToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :started_at, :date, null: false, default: Time.now
  end
end
