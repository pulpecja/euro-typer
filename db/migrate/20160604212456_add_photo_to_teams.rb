class AddPhotoToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :photo, :string
  end
end
