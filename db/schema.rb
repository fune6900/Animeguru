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

ActiveRecord::Schema[7.2].define(version: 2025_05_24_163900) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animes", force: :cascade do |t|
    t.string "title", null: false
    t.string "official_site_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["title"], name: "index_animes_on_title", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "seichi_memo_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seichi_memo_id"], name: "index_bookmarks_on_seichi_memo_id"
    t.index ["user_id", "seichi_memo_id"], name: "index_bookmarks_on_user_id_and_seichi_memo_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.bigint "seichi_memo_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seichi_memo_id"], name: "index_comments_on_seichi_memo_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "genre_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genre_tags_on_name", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "seichi_memo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seichi_memo_id"], name: "index_likes_on_seichi_memo_id"
    t.index ["user_id", "seichi_memo_id"], name: "index_likes_on_user_id_and_seichi_memo_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["name"], name: "index_places_on_name", unique: true
  end

  create_table "seichi_memos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "anime_id", null: false
    t.bigint "place_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "seichi_photo"
    t.string "scene_image"
    t.index ["anime_id"], name: "index_seichi_memos_on_anime_id"
    t.index ["place_id"], name: "index_seichi_memos_on_place_id"
    t.index ["user_id"], name: "index_seichi_memos_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "seichi_memo_id", null: false
    t.bigint "genre_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_tag_id"], name: "index_taggings_on_genre_tag_id"
    t.index ["seichi_memo_id", "genre_tag_id"], name: "index_taggings_on_seichi_memo_id_and_genre_tag_id", unique: true
    t.index ["seichi_memo_id"], name: "index_taggings_on_seichi_memo_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.text "introduction"
    t.string "profile_image"
    t.string "provider"
    t.string "uid"
    t.string "favorite_anime"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bookmarks", "seichi_memos"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "comments", "seichi_memos"
  add_foreign_key "comments", "users"
  add_foreign_key "likes", "seichi_memos"
  add_foreign_key "likes", "users"
  add_foreign_key "seichi_memos", "animes"
  add_foreign_key "seichi_memos", "places"
  add_foreign_key "seichi_memos", "users"
  add_foreign_key "taggings", "genre_tags"
  add_foreign_key "taggings", "seichi_memos"
end
