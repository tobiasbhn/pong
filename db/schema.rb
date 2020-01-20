# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_17_091223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "consumers", force: :cascade do |t|
    t.string "consumable_type"
    t.bigint "consumable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
    t.integer "instance_count", default: 0
    t.index ["consumable_type", "consumable_id"], name: "index_consumers_on_consumable_type_and_consumable_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "key"
    t.string "mode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "protect", default: false
    t.string "password_digest"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "game_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "game_key"
    t.datetime "enqueued_at", precision: 6
    t.integer "queue_pos"
    t.index ["game_id"], name: "index_users_on_game_id"
  end

end
