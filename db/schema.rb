# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160221190257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.string   "mbid"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "artists", ["mbid"], name: "index_artists_on_mbid", using: :btree
  add_index "artists", ["name"], name: "index_artists_on_name", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "remote_id"
    t.string   "name"
    t.string   "role"
    t.string   "image_url"
    t.string   "small_image_url"
    t.string   "link"
    t.string   "average_rating"
    t.string   "ratings_count"
    t.string   "text_reviews_count"
    t.integer  "book_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "authors", ["book_id"], name: "index_authors_on_book_id", using: :btree
  add_index "authors", ["remote_id"], name: "index_authors_on_remote_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.integer  "remote_id"
    t.integer  "text_reviews_count"
    t.string   "format"
    t.string   "isbn13"
    t.string   "title"
    t.string   "image_url"
    t.string   "small_image_url"
    t.string   "large_image_url"
    t.string   "num_pages"
    t.string   "ratings_count"
    t.string   "rating"
    t.string   "link"
    t.string   "published"
    t.string   "publisher"
    t.string   "publication_day"
    t.string   "publication_year"
    t.string   "publication_month"
    t.string   "average_rating"
    t.string   "isbn"
    t.string   "edition_information"
    t.text     "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "books", ["remote_id"], name: "index_books_on_remote_id", using: :btree

  create_table "headspace_pack_groups", force: :cascade do |t|
    t.boolean  "is_elective"
    t.integer  "total_packs"
    t.integer  "no_of_packs"
    t.string   "colour"
    t.string   "remote_pack_group_id"
    t.string   "icon_url"
    t.string   "name"
    t.string   "ldpi_icon_url"
    t.string   "mdpi_icon_url"
    t.string   "hdpi_icon_url"
    t.string   "xhdpi_icon_url"
    t.string   "xxhdpi_icon_url"
    t.integer  "headspace_stat_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "headspace_pack_groups", ["headspace_stat_id"], name: "index_headspace_pack_groups_on_headspace_stat_id", using: :btree
  add_index "headspace_pack_groups", ["remote_pack_group_id"], name: "index_headspace_pack_groups_on_remote_pack_group_id", using: :btree

  create_table "headspace_stats", force: :cascade do |t|
    t.integer  "number_of_minutes"
    t.integer  "current_run_streak"
    t.integer  "longest_run_streak"
    t.integer  "num_sessions"
    t.integer  "avg_session_length"
    t.string   "display_name"
    t.string   "last_name"
    t.string   "remote_user_id"
    t.string   "first_name"
    t.string   "last_meditated"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "headspace_stats", ["last_meditated"], name: "index_headspace_stats_on_last_meditated", using: :btree
  add_index "headspace_stats", ["remote_user_id"], name: "index_headspace_stats_on_remote_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "size"
    t.string   "content"
    t.integer  "top_track_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "images", ["size"], name: "index_images_on_size", using: :btree
  add_index "images", ["top_track_id"], name: "index_images_on_top_track_id", using: :btree

  create_table "streamables", force: :cascade do |t|
    t.string   "fulltrack"
    t.string   "content"
    t.integer  "top_track_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "streamables", ["top_track_id"], name: "index_streamables_on_top_track_id", using: :btree

  create_table "top_tags", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "top_tags", ["name"], name: "index_top_tags_on_name", using: :btree

  create_table "top_tags_tracks", id: false, force: :cascade do |t|
    t.integer  "top_track_id"
    t.integer  "top_tag_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "top_tags_tracks", ["top_tag_id"], name: "index_top_tags_tracks_on_top_tag_id", using: :btree
  add_index "top_tags_tracks", ["top_track_id"], name: "index_top_tags_tracks_on_top_track_id", using: :btree

  create_table "top_tracks", force: :cascade do |t|
    t.string   "rank"
    t.string   "name"
    t.string   "duration"
    t.string   "playcount"
    t.string   "mbid"
    t.string   "url"
    t.integer  "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "top_tracks", ["artist_id"], name: "index_top_tracks_on_artist_id", using: :btree
  add_index "top_tracks", ["mbid"], name: "index_top_tracks_on_mbid", using: :btree
  add_index "top_tracks", ["name"], name: "index_top_tracks_on_name", using: :btree
  add_index "top_tracks", ["url"], name: "index_top_tracks_on_url", using: :btree

  create_table "twitter_counts", force: :cascade do |t|
    t.integer  "current_followers_count"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "twitter_counts", ["created_at"], name: "index_twitter_counts_on_created_at", using: :btree
  add_index "twitter_counts", ["updated_at"], name: "index_twitter_counts_on_updated_at", using: :btree

end
