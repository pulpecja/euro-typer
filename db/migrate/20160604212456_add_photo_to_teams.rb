class AddPhotoToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :photo, :string
  end
end
