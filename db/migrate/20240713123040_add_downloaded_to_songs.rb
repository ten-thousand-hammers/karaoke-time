class AddDownloadedToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :downloaded, :boolean, default: false
    add_column :songs, :download_error, :text
    add_column :songs, :download_status, :integer
  end
end
