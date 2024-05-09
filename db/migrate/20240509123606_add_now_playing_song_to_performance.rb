class AddNowPlayingSongToPerformance < ActiveRecord::Migration[7.1]
  def change
    add_reference :performances, :now_playing_song, null: true, foreign_key: {to_table: :songs}
  end
end
