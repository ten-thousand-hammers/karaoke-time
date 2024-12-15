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

ActiveRecord::Schema[7.1].define(version: 2024_12_15_192507) do
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
    t.string "up_next_download_status"
    t.index ["now_playing_song_id"], name: "index_performances_on_now_playing_song_id"
    t.index ["now_playing_user_id"], name: "index_performances_on_now_playing_user_id"
    t.index ["up_next_song_id"], name: "index_performances_on_up_next_song_id"
    t.index ["up_next_user_id"], name: "index_performances_on_up_next_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
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
    t.integer "plays", default: 0, null: false
    t.boolean "downloaded", default: false
    t.text "download_error"
    t.integer "download_status"
    t.boolean "file_problem"
    t.boolean "not_embeddable"
  end

  create_table "user_songs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "song_id", null: false
    t.integer "plays", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_user_songs_on_song_id"
    t.index ["user_id"], name: "index_user_songs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "picture"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth0_id"
    t.integer "avatar"
    t.string "browser_id"
  end

  add_foreign_key "acts", "performances"
  add_foreign_key "acts", "songs"
  add_foreign_key "acts", "users"
  add_foreign_key "performances", "songs", column: "now_playing_song_id"
  add_foreign_key "performances", "songs", column: "up_next_song_id"
  add_foreign_key "performances", "users", column: "now_playing_user_id"
  add_foreign_key "performances", "users", column: "up_next_user_id"
  add_foreign_key "user_songs", "songs"
  add_foreign_key "user_songs", "users"
end
