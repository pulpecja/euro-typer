class AddPhotoForBase64ToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :photo, :text
  end
end
