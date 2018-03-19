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

ActiveRecord::Schema.define(version: 20180320001210) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.index ["user_id", "group_id"], name: "index_groups_users_on_user_id_and_group_id"
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "goal_id"
    t.string "name"
    t.integer "position"
    t.datetime "created_at", default: "2018-03-10 13:11:07", null: false
    t.datetime "updated_at", default: "2018-03-10 13:11:07", null: false
    t.boolean "done"
    t.integer "group_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "tg_id"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "language_code"
    t.boolean "is_bot"
    t.string "context"
    t.string "payload"
    t.datetime "created_at", default: "2018-03-10 13:11:07", null: false
    t.datetime "updated_at", default: "2018-03-10 13:11:07", null: false
    t.integer "current_group_id"
    t.index ["tg_id"], name: "index_users_on_tg_id", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

end
