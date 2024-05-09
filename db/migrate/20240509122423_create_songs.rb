class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.string :external_id
      t.string :name
      t.string :url
      t.float :duration
      t.json :thumbnails

      t.timestamps
    end
  end
end
