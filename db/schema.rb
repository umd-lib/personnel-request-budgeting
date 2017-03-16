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

ActiveRecord::Schema.define(version: 20170227175630) do

# Could not dump table "archived_contractor_requests" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

# Could not dump table "archived_labor_requests" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

# Could not dump table "archived_staff_requests" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "contractor_requests", force: :cascade do |t|
    t.integer  "employee_type_id"
    t.string   "position_title"
    t.integer  "request_type_id"
    t.string   "contractor_name"
    t.integer  "number_of_months",      default: 1
    t.decimal  "annual_base_pay_cents"
    t.decimal  "nonop_funds"
    t.string   "nonop_source"
    t.integer  "department_id"
    t.integer  "unit_id"
    t.text     "justification"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "review_status_id"
    t.text     "review_comment"
  end

  add_index "contractor_requests", ["department_id"], name: "index_contractor_requests_on_department_id"
  add_index "contractor_requests", ["employee_type_id"], name: "index_contractor_requests_on_employee_type_id"
  add_index "contractor_requests", ["request_type_id"], name: "index_contractor_requests_on_request_type_id"
  add_index "contractor_requests", ["unit_id"], name: "index_contractor_requests_on_unit_id"

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "division_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "code"
    t.integer  "units_count",                        default: 0
    t.integer  "contractor_requests_count",          default: 0
    t.integer  "labor_requests_count",               default: 0
    t.integer  "staff_requests_count",               default: 0
    t.integer  "archived_contractor_requests_count"
    t.integer  "archived_staff_requests_count"
    t.integer  "archived_labor_requests_count"
  end

  add_index "departments", ["code"], name: "index_departments_on_code", unique: true
  add_index "departments", ["division_id"], name: "index_departments_on_division_id"

  create_table "divisions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "code"
    t.integer  "departments_count",                  default: 0
    t.integer  "archived_contractor_requests_count"
    t.integer  "archived_staff_requests_count"
    t.integer  "archived_labor_requests_count"
  end

  add_index "divisions", ["code"], name: "index_divisions_on_code", unique: true

  create_table "employee_categories", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "employee_types_count", default: 0
  end

  add_index "employee_categories", ["code"], name: "index_employee_categories_on_code", unique: true

  create_table "employee_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "employee_category_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "contractor_requests_count",          default: 0
    t.integer  "labor_requests_count",               default: 0
    t.integer  "staff_requests_count",               default: 0
    t.integer  "archived_contractor_requests_count"
    t.integer  "archived_staff_requests_count"
    t.integer  "archived_labor_requests_count"
  end

  add_index "employee_types", ["code"], name: "index_employee_types_on_code", unique: true
  add_index "employee_types", ["employee_category_id"], name: "index_employee_types_on_employee_category_id"

  create_table "labor_requests", force: :cascade do |t|
    t.integer  "employee_type_id"
    t.string   "position_title"
    t.integer  "request_type_id"
    t.string   "contractor_name"
    t.integer  "number_of_positions", default: 1
    t.decimal  "hourly_rate_cents"
    t.decimal  "hours_per_week"
    t.integer  "number_of_weeks",     default: 1
    t.decimal  "nonop_funds"
    t.string   "nonop_source"
    t.integer  "department_id"
    t.integer  "unit_id"
    t.text     "justification"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "review_status_id"
    t.text     "review_comment"
  end

  add_index "labor_requests", ["department_id"], name: "index_labor_requests_on_department_id"
  add_index "labor_requests", ["employee_type_id"], name: "index_labor_requests_on_employee_type_id"
  add_index "labor_requests", ["request_type_id"], name: "index_labor_requests_on_request_type_id"
  add_index "labor_requests", ["unit_id"], name: "index_labor_requests_on_unit_id"

  create_table "reports", force: :cascade do |t|
    t.binary   "output"
    t.text     "parameters"
    t.integer  "format",         default: 0, null: false
    t.integer  "status",         default: 0, null: false
    t.string   "name",                       null: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "status_message"
  end

  add_index "reports", ["user_id"], name: "index_reports_on_user_id"

  create_table "request_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "contractor_requests_count",          default: 0
    t.integer  "labor_requests_count",               default: 0
    t.integer  "staff_requests_count",               default: 0
    t.integer  "archived_contractor_requests_count"
    t.integer  "archived_staff_requests_count"
    t.integer  "archived_labor_requests_count"
  end

  add_index "request_types", ["code"], name: "index_request_types_on_code", unique: true

  create_table "review_statuses", force: :cascade do |t|
    t.string   "name"
    t.string   "color",                              default: "#ffffff"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "code"
    t.integer  "contractor_requests_count",          default: 0
    t.integer  "labor_requests_count",               default: 0
    t.integer  "staff_requests_count",               default: 0
    t.integer  "archived_contractor_requests_count"
    t.integer  "archived_staff_requests_count"
    t.integer  "archived_labor_requests_count"
  end

  create_table "role_cutoffs", force: :cascade do |t|
    t.integer  "role_type_id"
    t.date     "cutoff_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "role_cutoffs", ["role_type_id"], name: "index_role_cutoffs_on_role_type_id", unique: true

  create_table "role_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "roles_count", default: 0
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_type_id"
    t.integer  "division_id"
    t.integer  "department_id"
    t.integer  "unit_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "roles", ["department_id"], name: "index_roles_on_department_id"
  add_index "roles", ["division_id"], name: "index_roles_on_division_id"
  add_index "roles", ["role_type_id"], name: "index_roles_on_role_type_id"
  add_index "roles", ["unit_id"], name: "index_roles_on_unit_id"
  add_index "roles", ["user_id"], name: "index_roles_on_user_id"

  create_table "staff_requests", force: :cascade do |t|
    t.integer  "employee_type_id"
    t.string   "position_title"
    t.integer  "request_type_id"
    t.decimal  "annual_base_pay_cents"
    t.decimal  "nonop_funds"
    t.string   "nonop_source"
    t.integer  "department_id"
    t.integer  "unit_id"
    t.text     "justification"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "review_status_id"
    t.text     "review_comment"
    t.string   "employee_name"
  end

  add_index "staff_requests", ["department_id"], name: "index_staff_requests_on_department_id"
  add_index "staff_requests", ["employee_type_id"], name: "index_staff_requests_on_employee_type_id"
  add_index "staff_requests", ["request_type_id"], name: "index_staff_requests_on_request_type_id"
  add_index "staff_requests", ["unit_id"], name: "index_staff_requests_on_unit_id"

  create_table "units", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "contractor_requests_count",          default: 0
    t.integer  "labor_requests_count",               default: 0
    t.integer  "staff_requests_count",               default: 0
    t.integer  "archived_contractor_requests_count"
    t.integer  "archived_staff_requests_count"
    t.integer  "archived_labor_requests_count"
  end

  add_index "units", ["code"], name: "index_units_on_code", unique: true
  add_index "units", ["department_id"], name: "index_units_on_department_id"

  create_table "users", force: :cascade do |t|
    t.string   "cas_directory_id"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "users", ["cas_directory_id"], name: "index_users_on_cas_directory_id", unique: true

end
