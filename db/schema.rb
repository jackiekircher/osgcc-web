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

ActiveRecord::Schema.define(version: 20140310182903) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "time_zone"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "description"
    t.integer  "organizer_id"
  end

  add_index "competitions", ["organizer_id"], name: "index_competitions_on_organizer_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "competition_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "teams_users", id: false, force: true do |t|
    t.integer "team_id"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.integer  "uid"
    t.string   "username"
    t.string   "image_url"
    t.boolean  "admin",      default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
