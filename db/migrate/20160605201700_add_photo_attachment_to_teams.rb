class AddPhotoAttachmentToTeams < ActiveRecord::Migration
  def self.up
    change_table :teams do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :teams, :photo
  end
end
