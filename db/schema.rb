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

ActiveRecord::Schema.define(version: 20160716145804) do

  create_table "account_snapshots", force: :cascade do |t|
    t.float    "value"
    t.string   "note"
    t.date     "month"
    t.integer  "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_snapshots_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.integer  "balance_type"
    t.boolean  "tax_advantaged", default: false
    t.string   "ticker"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

end
