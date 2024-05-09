class RemoveNowPlayingSongFromPerformances < ActiveRecord::Migration[7.1]
  def change
    remove_column :performances, :now_playing_song
  end
end
