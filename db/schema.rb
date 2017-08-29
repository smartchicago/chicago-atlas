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

ActiveRecord::Schema.define(version: 20170829171927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "category_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "datasets", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.string   "provider"
    t.string   "url"
    t.text     "metadata"
    t.integer  "category_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "data_type"
    t.string   "stat_type"
    t.boolean  "is_visible",  default: true
  end

  add_index "datasets", ["category_id"], name: "index_datasets_on_category_id", using: :btree

  create_table "demo_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "demography"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "geo_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "geography"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "geo_id"
    t.string   "part"
  end

  create_table "geographies", force: :cascade do |t|
    t.string   "geo_type"
    t.string   "name"
    t.string   "slug"
    t.text     "geometry"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "centroid"
    t.string   "adjacent_zips",            default: "[]"
    t.string   "adjacent_community_areas", default: "[]"
    t.string   "part"
  end

  create_table "hc_indicators", force: :cascade do |t|
    t.string   "category"
    t.string   "name"
    t.string   "most_recent_year"
    t.string   "priority_population"
    t.string   "priority_population_most_recent_year"
    t.string   "target"
    t.string   "datasource"
    t.string   "slug"
    t.integer  "upload_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "uploader_id"
    t.string   "datasource_url"
  end

  add_index "hc_indicators", ["uploader_id"], name: "index_hc_indicators_on_uploader_id", using: :btree

  create_table "indicator_map_colours", force: :cascade do |t|
    t.string   "slug"
    t.string   "map_key"
    t.string   "start_value"
    t.string   "end_value"
    t.string   "colour"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "indicator_properties", force: :cascade do |t|
    t.string   "slug"
    t.string   "order"
    t.string   "description"
    t.integer  "upload_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "uploader_id"
  end

  add_index "indicator_properties", ["uploader_id"], name: "index_indicator_properties_on_uploader_id", using: :btree

  create_table "indicators", force: :cascade do |t|
    t.string   "name"
    t.integer  "sub_category_id"
    t.string   "slug"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "indicators", ["sub_category_id"], name: "index_indicators_on_sub_category_id", using: :btree

  create_table "intervention_location_datasets", force: :cascade do |t|
    t.integer "intervention_location_id"
    t.integer "dataset_id"
  end

  add_index "intervention_location_datasets", ["intervention_location_id", "dataset_id"], name: "index_intervention_location_dataset_idx", using: :btree

  create_table "intervention_locations", force: :cascade do |t|
    t.string   "program_name"
    t.text     "hours",               default: ""
    t.string   "phone"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "dataset_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "tags",                default: ""
    t.string   "organization_name",   default: ""
    t.text     "categories",          default: ""
    t.string   "purple_binder_url",   default: ""
    t.string   "program_url",         default: ""
    t.integer  "community_area_id"
    t.integer  "geography_id"
    t.string   "community_area_name"
  end

  add_index "intervention_locations", ["geography_id"], name: "index_intervention_locations_on_geography_id", using: :btree

  create_table "provider_stats", force: :cascade do |t|
    t.integer  "provider_id"
    t.string   "stat_type"
    t.string   "stat"
    t.float    "value"
    t.datetime "date_start"
    t.datetime "date_end"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "data_type"
  end

  add_index "provider_stats", ["provider_id"], name: "index_provider_stats_on_provider_id", using: :btree
  add_index "provider_stats", ["stat_type"], name: "index_provider_stats_on_stat_type", using: :btree

  create_table "providers", force: :cascade do |t|
    t.integer  "src_id"
    t.string   "name"
    t.string   "slug"
    t.string   "primary_type"
    t.string   "sub_type"
    t.string   "addr_street"
    t.string   "addr_city"
    t.string   "addr_zip"
    t.string   "ownership_type"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "lat_long"
    t.text     "description"
    t.string   "phone"
    t.string   "url"
    t.string   "report_url"
    t.string   "report_name"
    t.text     "areas"
    t.string   "area_type"
    t.text     "area_alt"
    t.string   "chna_url"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "doc_embed_url"
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "uploader_id"
    t.integer  "category_group_id"
    t.integer  "sub_category_id"
    t.integer  "indicator_id"
    t.integer  "year_from"
    t.integer  "year_to"
    t.integer  "geo_group_id"
    t.integer  "demo_group_id"
    t.integer  "number"
    t.float    "cum_number"
    t.float    "ave_annual_number"
    t.float    "crude_rate"
    t.float    "lower_95ci_crude_rate"
    t.float    "upper_95ci_crude_rate"
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

  add_index "resources", ["category_group_id"], name: "index_resources_on_category_group_id", using: :btree
  add_index "resources", ["demo_group_id"], name: "index_resources_on_demo_group_id", using: :btree
  add_index "resources", ["geo_group_id"], name: "index_resources_on_geo_group_id", using: :btree
  add_index "resources", ["indicator_id"], name: "index_resources_on_indicator_id", using: :btree
  add_index "resources", ["sub_category_id"], name: "index_resources_on_sub_category_id", using: :btree
  add_index "resources", ["uploader_id"], name: "index_resources_on_uploader_id", using: :btree

  create_table "statistics", force: :cascade do |t|
    t.integer  "year"
    t.string   "name"
    t.float    "value"
    t.float    "lower_ci"
    t.float    "upper_ci"
    t.integer  "geography_id"
    t.integer  "dataset_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "year_range",   default: ""
  end

  add_index "statistics", ["dataset_id"], name: "index_statistics_on_dataset_id", using: :btree
  add_index "statistics", ["geography_id"], name: "index_statistics_on_geography_id", using: :btree

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_group_id"
    t.string   "slug"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "sub_categories", ["category_group_id"], name: "index_sub_categories_on_category_group_id", using: :btree

  create_table "uploaders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "comment"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "path"
    t.integer  "status"
    t.string   "name"
    t.integer  "total_row"
    t.integer  "current_row"
    t.integer  "indicator_id"
    t.integer  "category",     default: 0
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

  add_foreign_key "hc_indicators", "uploaders"
  add_foreign_key "indicator_properties", "uploaders"
  add_foreign_key "indicators", "sub_categories"
  add_foreign_key "intervention_locations", "geographies"
  add_foreign_key "resources", "category_groups"
  add_foreign_key "resources", "demo_groups"
  add_foreign_key "resources", "geo_groups"
  add_foreign_key "resources", "indicators"
  add_foreign_key "resources", "sub_categories"
  add_foreign_key "resources", "uploaders"
  add_foreign_key "sub_categories", "category_groups"
  add_foreign_key "uploaders", "users"
end
