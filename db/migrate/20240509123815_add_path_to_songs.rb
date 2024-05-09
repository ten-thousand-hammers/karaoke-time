class AddPathToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :path, :string
  end
end
