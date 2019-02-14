class AddStartedAtToRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :rounds, :started_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
