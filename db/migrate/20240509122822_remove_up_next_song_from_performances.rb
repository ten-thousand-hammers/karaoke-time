class RemoveUpNextSongFromPerformances < ActiveRecord::Migration[7.1]
  def change
    remove_column :performances, :up_next_song
  end
end
