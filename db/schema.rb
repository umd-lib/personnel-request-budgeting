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

ActiveRecord::Schema.define(version: 20160405194850) do

  create_table "contractor_requests", force: :cascade do |t|
    t.integer  "employee_type_id"
    t.string   "position_description"
    t.integer  "request_type_id"
    t.string   "contractor_name"
    t.integer  "number_of_months"
    t.decimal  "annual_base_pay"
    t.decimal  "nonop_funds"
    t.string   "nonop_source"
    t.integer  "department_id"
    t.integer  "subdepartment_id"
    t.text     "justification"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "contractor_requests", ["department_id"], name: "index_contractor_requests_on_department_id"
  add_index "contractor_requests", ["employee_type_id"], name: "index_contractor_requests_on_employee_type_id"
  add_index "contractor_requests", ["request_type_id"], name: "index_contractor_requests_on_request_type_id"
  add_index "contractor_requests", ["subdepartment_id"], name: "index_contractor_requests_on_subdepartment_id"

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "division_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "code"
  end

  add_index "departments", ["division_id"], name: "index_departments_on_division_id"

  create_table "divisions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "employee_categories", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "employee_category_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "employee_types", ["employee_category_id"], name: "index_employee_types_on_employee_category_id"

  create_table "labor_requests", force: :cascade do |t|
    t.integer  "employee_type_id"
    t.string   "position_description"
    t.integer  "request_type_id"
    t.string   "contractor_name"
    t.integer  "number_of_positions"
    t.decimal  "hourly_rate"
    t.decimal  "hours_per_week"
    t.integer  "number_of_weeks"
    t.decimal  "nonop_funds"
    t.string   "nonop_source"
    t.integer  "department_id"
    t.integer  "subdepartment_id"
    t.text     "justification"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "labor_requests", ["department_id"], name: "index_labor_requests_on_department_id"
  add_index "labor_requests", ["employee_type_id"], name: "index_labor_requests_on_employee_type_id"
  add_index "labor_requests", ["request_type_id"], name: "index_labor_requests_on_request_type_id"
  add_index "labor_requests", ["subdepartment_id"], name: "index_labor_requests_on_subdepartment_id"

  create_table "request_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staff_requests", force: :cascade do |t|
    t.integer  "employee_type_id"
    t.string   "position_description"
    t.integer  "request_type_id"
    t.decimal  "annual_base_pay"
    t.decimal  "nonop_funds"
    t.string   "nonop_source"
    t.integer  "department_id"
    t.integer  "subdepartment_id"
    t.text     "justification"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "staff_requests", ["department_id"], name: "index_staff_requests_on_department_id"
  add_index "staff_requests", ["employee_type_id"], name: "index_staff_requests_on_employee_type_id"
  add_index "staff_requests", ["request_type_id"], name: "index_staff_requests_on_request_type_id"
  add_index "staff_requests", ["subdepartment_id"], name: "index_staff_requests_on_subdepartment_id"

  create_table "subdepartments", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "subdepartments", ["department_id"], name: "index_subdepartments_on_department_id"

end
