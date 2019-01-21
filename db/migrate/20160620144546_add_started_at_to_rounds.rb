class AddStartedAtToRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :rounds, :started_at, :date, null: false, default: Time.now
  end
end
