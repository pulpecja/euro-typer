class AddBetToTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :types, :bet, :string
  end
end
