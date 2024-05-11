# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_11_141827) do
  create_table "acts", force: :cascade do |t|
    t.integer "song_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "performance_id"
    t.index ["performance_id"], name: "index_acts_on_performance_id"
    t.index ["song_id"], name: "index_acts_on_song_id"
    t.index ["user_id"], name: "index_acts_on_user_id"
  end

  create_table "performances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "now_playing_url"
    t.integer "up_next_song_id"
    t.integer "now_playing_song_id"
    t.integer "up_next_user_id"
    t.integer "now_playing_user_id"
    t.index ["now_playing_song_id"], name: "index_performances_on_now_playing_song_id"
    t.index ["now_playing_user_id"], name: "index_performances_on_now_playing_user_id"
    t.index ["up_next_song_id"], name: "index_performances_on_up_next_song_id"
    t.index ["up_next_user_id"], name: "index_performances_on_up_next_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "external_id"
    t.string "name"
    t.string "url"
    t.float "duration"
    t.json "thumbnails"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "path"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "picture"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "acts", "performances"
  add_foreign_key "acts", "songs"
  add_foreign_key "acts", "users"
  add_foreign_key "performances", "songs", column: "now_playing_song_id"
  add_foreign_key "performances", "songs", column: "up_next_song_id"
  add_foreign_key "performances", "users", column: "now_playing_user_id"
  add_foreign_key "performances", "users", column: "up_next_user_id"
end