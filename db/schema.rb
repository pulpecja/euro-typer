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

ActiveRecord::Schema.define(version: 20180609090159) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.integer  "year"
    t.string   "place"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "competitions_groups", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "group_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "competitions_groups", ["competition_id"], name: "index_competitions_groups_on_competition_id", using: :btree
  add_index "competitions_groups", ["group_id"], name: "index_competitions_groups_on_group_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "token"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "first_team_id",              null: false
    t.integer  "second_team_id",             null: false
    t.datetime "played",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_id"
    t.integer  "first_score"
    t.integer  "second_score"
    t.string   "bet",            limit: 255
  end

  create_table "rounds", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "started_at",                 default: '2016-06-20', null: false
    t.integer  "competition_id"
    t.integer  "stage"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation",       limit: 255
    t.string   "flag",               limit: 255
    t.string   "photo",              limit: 255
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "name_en"
  end

  create_table "types", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "match_id"
    t.integer  "first_score"
    t.integer  "second_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bet",          limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255,                null: false
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   limit: 255
    t.datetime "deleted_at"
    t.string   "photo_file_name",        limit: 255
    t.string   "photo_content_type",     limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "take_part",                          default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "winner_types", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.integer "competition_id"
  end

  add_index "winner_types", ["competition_id"], name: "index_winner_types_on_competition_id", using: :btree
  add_index "winner_types", ["team_id"], name: "index_winner_types_on_team_id", using: :btree
  add_index "winner_types", ["user_id"], name: "index_winner_types_on_user_id", using: :btree

  add_foreign_key "competitions_groups", "competitions"
  add_foreign_key "competitions_groups", "groups"
  add_foreign_key "groups_users", "groups"
  add_foreign_key "groups_users", "users"
  add_foreign_key "winner_types", "competitions"
  add_foreign_key "winner_types", "teams"
  add_foreign_key "winner_types", "users"
end
