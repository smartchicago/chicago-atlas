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

ActiveRecord::Schema.define(version: 20170110021409) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "demo_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "demography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "geo_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "geography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "indicators", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "uploader_id"
    t.integer  "category_id"
    t.integer  "sub_category_id"
    t.integer  "indicator_id"
    t.integer  "year"
    t.integer  "geo_group_id"
    t.integer  "demo_group_id"
    t.integer  "number"
    t.float    "cum_number"
    t.float    "ave_annual_number"
    t.float    "crude_rate"
    t.float    "lower_95ci_crude_rate"
    t.float    "uppper_95ci_crude_rate"
    t.float    "age_adj_rate"
    t.float    "lower_95ci_adj_rate"
    t.float    "upper_95ci_adj_rate"
    t.float    "percent"
    t.float    "lower_95ci_percent"
    t.float    "upper_95ci_percent"
    t.float    "weight_number"
    t.float    "weight_percent"
    t.float    "lower_95ci_weight_percent"
    t.float    "upper_95ci_weight_percent"
    t.string   "map_key"
    t.string   "flag"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "uploaders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "path"
    t.integer  "status"
    t.string   "name"
    t.integer  "total_row"
    t.integer  "current_row"
  end

  add_index "uploaders", ["user_id"], name: "index_uploaders_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "uploaders", "users"
end
