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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140421220144) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "datasets", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.string   "provider"
    t.string   "url"
    t.text     "metadata"
    t.integer  "category_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "data_type"
    t.string   "stat_type"
    t.boolean  "is_visible",  :default => true
  end

  add_index "datasets", ["category_id"], :name => "index_datasets_on_category_id"

  create_table "geographies", :force => true do |t|
    t.string   "geo_type"
    t.string   "name"
    t.string   "slug"
    t.text     "geometry"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "centroid"
    t.string   "adjacent_zips",            :default => "[]"
    t.string   "adjacent_community_areas", :default => "[]"
  end

  create_table "intervention_location_datasets", :force => true do |t|
    t.integer "intervention_location_id"
    t.integer "dataset_id"
  end

  add_index "intervention_location_datasets", ["intervention_location_id", "dataset_id"], :name => "index_intervention_location_dataset_idx"

  create_table "intervention_locations", :force => true do |t|
    t.string   "program_name"
    t.text     "hours",             :default => ""
    t.string   "phone"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "dataset_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.text     "tags",              :default => ""
    t.string   "organization_name", :default => ""
    t.text     "categories",        :default => ""
    t.string   "purple_binder_url", :default => ""
    t.string   "program_url",       :default => ""
    t.integer  "community_area_id"
  end

  create_table "statistics", :force => true do |t|
    t.integer  "year"
    t.string   "name"
    t.float    "value"
    t.float    "lower_ci"
    t.float    "upper_ci"
    t.integer  "geography_id"
    t.integer  "dataset_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "year_range",   :default => ""
  end

  add_index "statistics", ["dataset_id"], :name => "index_statistics_on_dataset_id"
  add_index "statistics", ["geography_id"], :name => "index_statistics_on_geography_id"

end
