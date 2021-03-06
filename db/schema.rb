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

ActiveRecord::Schema.define(version: 20160907013310) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "postgis"

  create_table "account_snapshots", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.float    "value"
    t.string   "note"
    t.date     "month"
    t.uuid     "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_snapshots_on_account_id", using: :btree
  end

  create_table "accounts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.integer  "balance_type"
    t.boolean  "tax_advantaged", default: false
    t.string   "ticker"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "ar_internal_metadata", primary_key: "key", id: :string, force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.float    "value"
    t.string   "note"
    t.date     "date"
    t.string   "description"
    t.string   "location"
    t.boolean  "is_split",                                       default: false
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.geometry "coordinate",  limit: {:srid=>0, :type=>"point"}
  end


  create_view :net_worth_snapshots,  sql_definition: <<-SQL
      SELECT account_snapshots.month,
      sum(account_snapshots.value) AS total
     FROM account_snapshots
    GROUP BY account_snapshots.month;
  SQL

end
