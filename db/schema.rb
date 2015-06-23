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

ActiveRecord::Schema.define(version: 20150622192728) do

  create_table "city_council_domains", force: :cascade do |t|
    t.string   "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "city_council_responsible_people", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "author"
    t.text     "text"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "suggestion_id"
    t.string   "email"
    t.boolean  "visible",            default: false
    t.boolean  "support",            default: false
    t.boolean  "city_council_staff", default: false
    t.integer  "vote"
    t.string   "token_validation"
  end

  add_index "comments", ["suggestion_id"], name: "index_comments_on_suggestion_id"

  create_table "suggestions", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.string   "email"
    t.text     "comment"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "image1_id"
    t.string   "image2_id"
    t.string   "token_validation"
    t.boolean  "visible",              default: false
    t.string   "slug"
    t.string   "address"
    t.integer  "category"
    t.boolean  "notice_of_inactivity", default: false
    t.integer  "closed",               default: 0
  end

  add_index "suggestions", ["slug"], name: "index_suggestions_on_slug"

  create_table "white_list_emails", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
