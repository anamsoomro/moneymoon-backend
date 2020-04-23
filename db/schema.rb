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

ActiveRecord::Schema.define(version: 2020_04_22_191806) do

  create_table "accounts", force: :cascade do |t|
  end

  create_table "plaid_accounts", force: :cascade do |t|
    t.integer "plaid_item_id"
    t.string "p_account_id"
    t.string "p_name"
    t.string "p_mask"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "plaid_items", force: :cascade do |t|
    t.integer "user_id"
    t.string "p_access_token"
    t.string "p_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "account_id"
    t.string "username"
    t.string "password_digest"
    t.string "email"
  end

end
