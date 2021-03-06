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

ActiveRecord::Schema.define(version: 20140330165622) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "event_links", force: true do |t|
    t.integer  "event_id"
    t.integer  "eventable_id"
    t.string   "eventable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "event_type", default: 0, null: false
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "organization_id"
    t.string   "timezone"
    t.datetime "registration_start"
    t.datetime "registration_end"
    t.datetime "game_start"
    t.datetime "game_end"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "options"
  end

  add_index "games", ["organization_id", "slug"], name: "index_games_on_organization_id_and_slug", unique: true, using: :btree
  add_index "games", ["organization_id"], name: "index_games_on_organization_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "location"
    t.string   "timezone"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree
  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "players", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "human_code"
    t.integer  "oz_status",  default: 0, null: false
  end

  add_index "players", ["game_id", "human_code"], name: "index_players_on_game_id_and_human_code", unique: true, using: :btree
  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree
  add_index "players", ["user_id", "game_id"], name: "index_players_on_user_id_and_game_id", unique: true, using: :btree
  add_index "players", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "tags", force: true do |t|
    t.integer  "tagger_id"
    t.integer  "taggee_id"
    t.datetime "claimed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source",     default: 0, null: false
  end

  add_index "tags", ["taggee_id"], name: "index_tags_on_taggee_id", unique: true, using: :btree
  add_index "tags", ["tagger_id"], name: "index_tags_on_tagger_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "screen_name",            default: "email", null: false
    t.string   "email",                  default: "",      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false,   null: false
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["screen_name"], name: "index_users_on_screen_name", unique: true, using: :btree

end
