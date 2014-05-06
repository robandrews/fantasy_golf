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

ActiveRecord::Schema.define(version: 20140505212928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archived_weeks", force: true do |t|
    t.integer  "league_id"
    t.integer  "season_id"
    t.integer  "week_id"
    t.text     "roster"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "archived_weeks", ["league_id"], name: "index_archived_weeks_on_league_id", using: :btree
  add_index "archived_weeks", ["week_id"], name: "index_archived_weeks_on_week_id", using: :btree

  create_table "bylaws", force: true do |t|
    t.integer  "league_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "division_memberships", force: true do |t|
    t.integer  "division_id"
    t.integer  "league_membership_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: true do |t|
    t.integer  "league_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_agent_offers", force: true do |t|
    t.integer  "player_id"
    t.datetime "expiry_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "user_name"
    t.boolean  "contested",   default: false
  end

  create_table "friendly_id_slugs", force: true do |t|
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

  create_table "interested_parties", force: true do |t|
    t.integer  "league_membership_id"
    t.integer  "free_agent_offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "league_memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "season_points", default: 0.0
    t.string   "name"
  end

  create_table "league_moderatorships", force: true do |t|
    t.integer  "league_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secret_sauce"
    t.string   "slug"
  end

  add_index "leagues", ["slug"], name: "index_leagues_on_slug", unique: true, using: :btree

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.string   "subject"
    t.text     "body"
    t.integer  "league_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sender_name"
  end

  create_table "players", force: true do |t|
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "picture_url"
    t.date     "birthdate"
    t.integer  "weight"
    t.integer  "height"
    t.string   "last_name"
    t.string   "birth_place"
    t.string   "college"
    t.integer  "career_earnings"
    t.boolean  "playable",        default: true
    t.integer  "yahoo_id"
  end

  create_table "roster_memberships", force: true do |t|
    t.integer  "league_membership_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",               default: false
  end

  create_table "season_performances", force: true do |t|
    t.integer  "user_id"
    t.integer  "season_id"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "tournament_standings", force: true do |t|
    t.integer  "player_id"
    t.integer  "tournament_id"
    t.integer  "winnings"
    t.string   "to_par"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "fantasy_points"
    t.integer  "int_position"
    t.integer  "yahoo_id"
  end

  add_index "tournament_standings", ["player_id"], name: "index_tournament_standings_on_player_id", using: :btree
  add_index "tournament_standings", ["tournament_id"], name: "index_tournament_standings_on_tournament_id", using: :btree

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete"
    t.integer  "week_id"
  end

  create_table "trade_group_memberships", force: true do |t|
    t.integer  "player_id"
    t.integer  "trade_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trade_groups", force: true do |t|
    t.integer  "trade_id"
    t.integer  "league_membership_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trades", force: true do |t|
    t.integer  "proposer_id"
    t.integer  "proposee_id"
    t.boolean  "accepted",    default: false
    t.boolean  "pending",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weeks", force: true do |t|
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "week_order"
  end

end
