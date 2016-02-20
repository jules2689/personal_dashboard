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

ActiveRecord::Schema.define(version: 20160220143905) do
  create_table "artists", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "mbid",       limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "artists", ["mbid"], name: "index_artists_on_mbid", using: :btree
  add_index "artists", ["name"], name: "index_artists_on_name", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "remote_id",          limit: 255
    t.string   "name",               limit: 255
    t.string   "role",               limit: 255
    t.string   "image_url",          limit: 255
    t.string   "small_image_url",    limit: 255
    t.string   "link",               limit: 255
    t.string   "average_rating",     limit: 255
    t.string   "ratings_count",      limit: 255
    t.string   "text_reviews_count", limit: 255
    t.integer  "book_id",            limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "authors", ["book_id"], name: "index_authors_on_book_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.integer  "remote_id",           limit: 4
    t.integer  "text_reviews_count",  limit: 4
    t.string   "format",              limit: 255
    t.string   "isbn13",              limit: 255
    t.string   "title",               limit: 255
    t.string   "image_url",           limit: 255
    t.string   "small_image_url",     limit: 255
    t.string   "large_image_url",     limit: 255
    t.string   "num_pages",           limit: 255
    t.string   "ratings_count",       limit: 255
    t.string   "link",                limit: 255
    t.string   "published",           limit: 255
    t.string   "publisher",           limit: 255
    t.string   "publication_day",     limit: 255
    t.string   "publication_year",    limit: 255
    t.string   "publication_month",   limit: 255
    t.string   "average_rating",      limit: 255
    t.string   "isbn",                limit: 255
    t.string   "edition_information", limit: 255
    t.text     "description",         limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "size",         limit: 255
    t.string   "content",      limit: 255
    t.integer  "top_track_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "images", ["size"], name: "index_images_on_size", using: :btree
  add_index "images", ["top_track_id"], name: "index_images_on_top_track_id", using: :btree

  create_table "streamables", force: :cascade do |t|
    t.string   "fulltrack",    limit: 255
    t.string   "content",      limit: 255
    t.integer  "top_track_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "streamables", ["top_track_id"], name: "index_streamables_on_top_track_id", using: :btree

  create_table "top_tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "top_tags", ["name"], name: "index_top_tags_on_name", using: :btree

  create_table "top_tags_tracks", id: false, force: :cascade do |t|
    t.integer  "top_track_id", limit: 4
    t.integer  "top_tag_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "top_tags_tracks", ["top_tag_id"], name: "index_top_tags_tracks_on_top_tag_id", using: :btree
  add_index "top_tags_tracks", ["top_track_id"], name: "index_top_tags_tracks_on_top_track_id", using: :btree

  create_table "top_tracks", force: :cascade do |t|
    t.string   "rank",       limit: 255
    t.string   "name",       limit: 255
    t.string   "duration",   limit: 255
    t.string   "playcount",  limit: 255
    t.string   "mbid",       limit: 255
    t.string   "url",        limit: 255
    t.integer  "artist_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "top_tracks", ["artist_id"], name: "index_top_tracks_on_artist_id", using: :btree
  add_index "top_tracks", ["mbid"], name: "index_top_tracks_on_mbid", using: :btree
  add_index "top_tracks", ["name"], name: "index_top_tracks_on_name", using: :btree
  add_index "top_tracks", ["url"], name: "index_top_tracks_on_url", using: :btree

  create_table "twitter_counts", force: :cascade do |t|
    t.integer  "current_followers_count", limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "twitter_counts", ["created_at"], name: "index_twitter_counts_on_created_at", using: :btree
  add_index "twitter_counts", ["updated_at"], name: "index_twitter_counts_on_updated_at", using: :btree
end
