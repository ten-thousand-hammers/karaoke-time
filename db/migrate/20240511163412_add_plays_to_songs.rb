class AddPlaysToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :plays, :integer, null: false, default: 0
  end
end
