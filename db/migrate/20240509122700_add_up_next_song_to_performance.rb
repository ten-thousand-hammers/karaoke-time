class AddUpNextSongToPerformance < ActiveRecord::Migration[7.1]
  def change
    add_reference :performances, :up_next_song, null: true, foreign_key: {to_table: :songs}
  end
end
