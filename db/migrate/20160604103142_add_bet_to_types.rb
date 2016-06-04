class AddBetToTypes < ActiveRecord::Migration
  def change
    add_column :types, :bet, :string
  end
end
