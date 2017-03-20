class AddFiscalRollover < ActiveRecord::Migration
  def change

    %w( contractor_requests staff_requests labor_requests ).each do |table|

        create_table "archived_#{table}", force: :cascade do |t|
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
          t.text     "fiscal_year" 
        end
      
        %i( employee_types review_statuses request_types divisions departments units  ).each do |m| 
          add_column m, "archived_#{table}_count".intern, :integer
        end

    end
    
  end
end
