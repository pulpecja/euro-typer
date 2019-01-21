class AddPhotoAttachmentToTeams < ActiveRecord::Migration[5.2]
  def self.up
    change_table :teams do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :teams, :photo
  end
end
