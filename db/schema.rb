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

ActiveRecord::Schema.define(:version => 20121019190104) do

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "local_name"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "population"
  end

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "download_statistics", :force => true do |t|
    t.integer  "ip"
    t.integer  "file_id"
    t.integer  "year_in_tz"
    t.integer  "month_in_tz"
    t.integer  "day_in_tz"
    t.integer  "hour_in_tz"
    t.integer  "minute_in_tz"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "download_statistics", ["file_id", "ip", "year_in_tz", "month_in_tz", "day_in_tz", "hour_in_tz", "minute_in_tz"], :name => "with_date"

  create_table "managers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "people", :force => true do |t|
    t.integer  "city_of_birth_id"
    t.string   "name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "purchases", :force => true do |t|
    t.string   "payment_system"
    t.float    "sum"
    t.integer  "client_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "ticket_messages", :force => true do |t|
    t.integer  "ticket_id"
    t.string   "sender_type"
    t.integer  "sender_id"
    t.string   "message"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tickets", :force => true do |t|
    t.string   "subject"
    t.integer  "client_id"
    t.string   "initiator_type"
    t.integer  "initiator_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "visits", :force => true do |t|
    t.integer  "person_id"
    t.integer  "city_id"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
