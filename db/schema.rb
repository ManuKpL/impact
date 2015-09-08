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

ActiveRecord::Schema.define(version: 20150908094014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.string   "name"
    t.string   "screen_name"
    t.string   "description"
    t.integer  "followers_count"
    t.integer  "following_count"
    t.integer  "listed"
    t.integer  "tweets_count"
    t.date     "account_creation"
    t.string   "picture"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "party"
  end

  create_table "interactions", force: :cascade do |t|
    t.integer  "candidate_id"
    t.string   "data_type"
    t.integer  "average"
    t.integer  "percentage"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "interactions", ["candidate_id"], name: "index_interactions_on_candidate_id", using: :btree

  create_table "topwords", force: :cascade do |t|
    t.integer  "candidate_id"
    t.string   "data_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "topwords", ["candidate_id"], name: "index_topwords_on_candidate_id", using: :btree

  create_table "twitterdata", force: :cascade do |t|
    t.integer  "candidate_id"
    t.string   "id_twitter"
    t.string   "data_type"
    t.binary   "data"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "twitterdata", ["candidate_id"], name: "index_twitterdata_on_candidate_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.integer  "topword_id"
    t.string   "content"
    t.integer  "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "words", ["topword_id"], name: "index_words_on_topword_id", using: :btree

  add_foreign_key "interactions", "candidates"
  add_foreign_key "topwords", "candidates"
  add_foreign_key "twitterdata", "candidates"
  add_foreign_key "words", "topwords"
end
