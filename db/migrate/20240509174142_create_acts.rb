class CreateActs < ActiveRecord::Migration[7.1]
  def change
    create_table :acts do |t|
      t.references :song, null: false, foreign_key: true
      t.text :user

      t.timestamps
    end
  end
end
