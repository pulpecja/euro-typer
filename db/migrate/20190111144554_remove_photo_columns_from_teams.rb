class RemovePhotoColumnsFromTeams < ActiveRecord::Migration[5.2]
  def up
    remove_column :teams, :photo
    remove_column :teams, :photo_file_name
    remove_column :teams, :photo_content_type
    remove_column :teams, :photo_file_size
    remove_column :teams, :photo_updated_at
  end

  def down
    add_column :teams, :photo, :string
    add_column :teams, :photo_file_name, :string
    add_column :teams, :photo_content_type, :string
    add_column :teams, :photo_file_size, :integer
    add_column :teams, :photo_updated_at, :datetime
  end
end
