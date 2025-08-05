# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_05_012840) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "symbol", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_currencies_on_name", unique: true
    t.index ["symbol"], name: "index_currencies_on_symbol", unique: true
  end

  create_table "price_snapshots", force: :cascade do |t|
    t.bigint "currency_id", null: false
    t.decimal "last"
    t.decimal "bid"
    t.decimal "ask"
    t.datetime "captured_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["captured_at"], name: "index_price_snapshots_on_captured_at"
    t.index ["currency_id", "captured_at"], name: "index_price_snapshots_on_currency_id_and_captured_at"
    t.index ["currency_id"], name: "index_price_snapshots_on_currency_id"
  end

  add_foreign_key "price_snapshots", "currencies"
end
