class CreatePlayedActs < ActiveRecord::Migration[7.1]
  def change
    create_table :played_acts do |t|
      t.references :performance, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :played_at

      t.timestamps
    end
  end
end
