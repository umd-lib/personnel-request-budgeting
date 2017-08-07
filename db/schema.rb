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

ActiveRecord::Schema.define(version: 20170328113652) do

  create_table "archived_requests", force: :cascade do |t|
    t.string   "position_title"
    t.integer  "request_model_type"
    t.integer  "request_type"
    t.integer  "employee_type"
    t.decimal  "annual_base_pay_cents"
    t.string   "contractor_name"
    t.integer  "number_of_months"
    t.integer  "number_of_positions"
    t.decimal  "hourly_rate_cents"
    t.decimal  "hours_per_week"
    t.integer  "number_of_weeks"
    t.decimal  "nonop_funds"
    t.string   "nonop_source"
    t.integer  "organization_id"
    t.integer  "review_status_id"
    t.text     "justification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "review_comment"
    t.string   "employee_name"
    t.datetime "fiscal_year"
  end

  add_index "archived_requests", ["organization_id"], name: "index_archived_requests_on_organization_id"
  add_index "archived_requests", ["review_status_id"], name: "index_archived_requests_on_review_status_id"

  create_table "organization_cutoffs", primary_key: "organization_type", force: :cascade do |t|
    t.date     "cutoff_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "organization_id"
    t.integer  "organization_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "organizations", ["code"], name: "index_organizations_on_code", unique: true
  add_index "organizations", ["organization_id"], name: "index_organizations_on_organization_id"
  add_index "organizations", ["organization_type"], name: "index_organizations_on_organization_type"

  create_table "requests", force: :cascade do |t|
    t.string   "position_title"
    t.integer  "request_model_type"
    t.integer  "request_type"
    t.integer  "employee_type"
    t.decimal  "annual_base_pay_cents"
    t.string   "contractor_name"
    t.integer  "number_of_months"
    t.integer  "number_of_positions"
    t.decimal  "hourly_rate_cents"
    t.decimal  "hours_per_week"
    t.integer  "number_of_weeks"
    t.decimal  "nonop_funds_cents"
    t.string   "nonop_source"
    t.integer  "organization_id"
    t.integer  "review_status_id"
    t.text     "justification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "review_comment"
    t.string   "employee_name"
  end

  add_index "requests", ["organization_id"], name: "index_requests_on_organization_id"
  add_index "requests", ["review_status_id"], name: "index_requests_on_review_status_id"

  create_table "review_statuses", force: :cascade do |t|
    t.string   "name"
    t.string   "color",          default: "#ffffff"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "code"
    t.integer  "requests_count", default: 0
  end

  create_table "roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_id"
  end

  add_index "roles", ["organization_id"], name: "index_roles_on_organization_id"
  add_index "roles", ["user_id"], name: "index_roles_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "cas_directory_id"
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "admin",            default: false
  end

end
