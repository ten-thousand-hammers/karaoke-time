class CreatePerformances < ActiveRecord::Migration[7.1]
  def change
    create_table :performances do |t|
      # t.references :now_playing_song, null: false, foreign_key: { to_table: :songs }
      # t.references :now_playing_user, null: false, foreign_key: { to_table: :users }
      # t.references :up_next_song, null: false, foreign_key: { to_table: :songs }
      # t.references :up_next_user, null: false, foreign_key: { to_table: :users }
      t.string :now_playing_song
      t.string :now_playing_user
      t.string :up_next_song
      t.string :up_next_user

      t.timestamps
    end
  end
end
