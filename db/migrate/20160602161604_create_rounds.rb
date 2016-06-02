class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :name

      t.timestamps
    end
  end
end
