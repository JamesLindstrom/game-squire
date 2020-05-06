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

ActiveRecord::Schema.define(version: 2020_05_06_031834) do

  create_table "creatures", force: :cascade do |t|
    t.string "name", null: false
    t.integer "variety", null: false
    t.integer "armor_class"
    t.integer "initiative_bonus"
    t.boolean "advantage"
    t.integer "initiative_value"
    t.integer "user_id"
    t.index ["user_id"], name: "index_creatures_on_user_id"
  end

  create_table "creatures_encounters", id: false, force: :cascade do |t|
    t.integer "creature_id", null: false
    t.integer "encounter_id", null: false
    t.integer "initiative"
  end

  create_table "creatures_game_spaces", id: false, force: :cascade do |t|
    t.integer "creature_id", null: false
    t.integer "game_space_id", null: false
  end

  create_table "encounters", force: :cascade do |t|
    t.string "name", null: false
    t.json "history"
    t.integer "game_space_id"
    t.index ["game_space_id"], name: "index_encounters_on_game_space_id"
  end

  create_table "game_spaces", force: :cascade do |t|
    t.string "name", null: false
    t.string "link", null: false
    t.boolean "public", default: false, null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_game_spaces_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
