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

ActiveRecord::Schema.define(version: 20160413033053) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "game_players", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.boolean  "is_master",  default: false
    t.integer  "score"
    t.boolean  "ships_left", default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "game_players", ["game_id"], name: "index_game_players_on_game_id", using: :btree
  add_index "game_players", ["user_id"], name: "index_game_players_on_user_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "name",                           null: false
    t.string   "password"
    t.string   "channel",                        null: false
    t.boolean  "is_completed", default: false
    t.boolean  "is_playing",   default: false
    t.integer  "num_players",                    null: false
    t.string   "type",         default: "Chaos", null: false
    t.string   "random"
    t.string   "slug"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "guesses", force: :cascade do |t|
    t.integer  "game_player_id"
    t.string   "row"
    t.string   "column"
    t.boolean  "is_hit"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "guesses", ["game_player_id"], name: "index_guesses_on_game_player_id", using: :btree

  create_table "ship_cells", force: :cascade do |t|
    t.integer  "ship_id"
    t.string   "row"
    t.string   "column"
    t.boolean  "is_hit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ship_cells", ["ship_id"], name: "index_ship_cells_on_ship_id", using: :btree

  create_table "ships", force: :cascade do |t|
    t.integer  "game_player_id"
    t.boolean  "is_sunk"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "ships", ["game_player_id"], name: "index_ships_on_game_player_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "games_played",           default: 0
    t.integer  "high_score",             default: 0
    t.float    "avg_score",              default: 0.0
    t.integer  "wins",                   default: 0
    t.integer  "losses",                 default: 0
    t.integer  "total_score",            default: 0
    t.string   "slug"
    t.integer  "current_channel",        default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "game_players", "games"
  add_foreign_key "game_players", "users"
  add_foreign_key "guesses", "game_players"
  add_foreign_key "ship_cells", "ships"
  add_foreign_key "ships", "game_players"
end
