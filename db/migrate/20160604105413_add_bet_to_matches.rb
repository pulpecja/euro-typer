class AddBetToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :bet, :string
  end
end
