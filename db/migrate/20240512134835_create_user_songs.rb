class CreateUserSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :user_songs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.integer :plays, null: false, default: 0

      t.timestamps
    end
  end
end
