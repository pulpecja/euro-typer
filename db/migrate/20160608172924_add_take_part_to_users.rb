class AddTakePartToUsers < ActiveRecord::Migration
  def change
    add_column :users, :take_part, :boolean, default: true
  end
end
