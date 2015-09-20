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

ActiveRecord::Schema.define(version: 20150913222737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "category_id"
    t.boolean  "archived"
  end

  create_table "activities_members", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived"
  end

  create_table "classrooms", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "level"
  end

  create_table "families", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived"
  end

  create_table "hours", force: :cascade do |t|
    t.integer  "member_id"
    t.float    "quantity"
    t.datetime "date_earned"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subactivity_id"
    t.integer  "submitted_by_id"
  end

  create_table "members", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "relationship_to_student"
    t.string  "email"
    t.string  "phone"
    t.integer "family_id"
    t.integer "user_id"
    t.string  "street_address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.boolean "archived"
    t.text    "comments"
  end

  create_table "school_years", force: :cascade do |t|
    t.string   "begin_year"
    t.string   "end_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_years_students", force: :cascade do |t|
    t.integer "student_id"
    t.integer "school_year_id"
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "classroom_id"
    t.string   "grade"
    t.boolean  "enrolled"
    t.integer  "family_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived"
  end

  create_table "subactivities", force: :cascade do |t|
    t.string   "name"
    t.integer  "activity_id"
    t.integer  "assigned_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archived"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "registration_token"
    t.integer  "member_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
