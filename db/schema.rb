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

ActiveRecord::Schema.define(version: 20160114082857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dashboards", force: :cascade do |t|
    t.string   "title",                     null: false
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "widgets", force: :cascade do |t|
    t.string   "title",                        null: false
    t.string   "category",                     null: false
    t.boolean  "active",        default: true
    t.integer  "dashboard_id",                 null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "uuid",                         null: false
    t.json     "configuration", default: {},   null: false
  end

  add_index "widgets", ["dashboard_id"], name: "index_widgets_on_dashboard_id", using: :btree
  add_index "widgets", ["uuid"], name: "index_widgets_on_uuid", unique: true, using: :btree

end
