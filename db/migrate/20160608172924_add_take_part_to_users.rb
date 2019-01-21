class AddTakePartToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :take_part, :boolean, default: true
  end
end
