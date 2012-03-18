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

ActiveRecord::Schema.define(:version => 20120317163557) do

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carmodel_oils", :id => false, :force => true do |t|
    t.integer  "carmodel_id",  :null => false
    t.integer  "oil_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "km"
    t.float    "km_warning"
    t.float    "hour"
    t.float    "hour_warning"
  end

  create_table "carmodels", :force => true do |t|
    t.integer  "brand_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "carmodel_type"
  end

  create_table "data_files", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_cells", :force => true do |t|
    t.integer  "import_table_id"
    t.integer  "row_index"
    t.integer  "column_index"
    t.string   "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_cells", ["import_table_id"], :name => "index_import_cells_on_import_table_id"

  create_table "import_tables", :force => true do |t|
    t.string   "original_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "machine_historics", :force => true do |t|
    t.integer  "vehicle_id"
    t.integer  "oil_id"
    t.float    "hour_initial"
    t.date     "date"
    t.text     "observation"
    t.boolean  "email",        :default => false
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oils", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_vehicle_historics", :force => true do |t|
    t.integer  "vehicle_id"
    t.integer  "place_id"
    t.integer  "oil_id"
    t.date     "initial_date"
    t.date     "end_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "login",                             :null => false
    t.string   "email",                             :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true

  create_table "vehicle_dailies", :force => true do |t|
    t.integer  "vehicle_id"
    t.float    "km"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "hour"
  end

  create_table "vehicle_historics", :force => true do |t|
    t.integer  "vehicle_id"
    t.integer  "oil_id"
    t.float    "km_initial"
    t.date     "date"
    t.text     "observation"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "email",       :default => false
  end

  create_table "vehicles", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "carmodel_id"
    t.string   "license_plate"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
  end

end
