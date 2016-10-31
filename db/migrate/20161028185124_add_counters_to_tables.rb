class AddCountersToTables < ActiveRecord::Migration
  def change
    add_column :role_types, :roles_count, :integer, default: 0
    add_column :divisions, :departments_count, :integer, default: 0
 
    add_column :departments, :units_count, :integer, default: 0
    add_column :departments, :contractor_requests_count, :integer, default: 0
    add_column :departments, :labor_requests_count, :integer, default: 0
    add_column :departments, :staff_requests_count, :integer, default: 0
    
    add_column :units, :contractor_requests_count, :integer, default: 0
    add_column :units, :labor_requests_count, :integer, default: 0
    add_column :units, :staff_requests_count, :integer, default: 0
    
    add_column :employee_categories, :employee_types_count, :integer, default: 0
    #add_column :divisions, :departments_count, :integer, default: 0
    
    add_column :employee_types, :contractor_requests_count, :integer, default: 0
    add_column :employee_types, :labor_requests_count, :integer, default: 0
    add_column :employee_types, :staff_requests_count, :integer, default: 0
    
    add_column :request_types, :contractor_requests_count, :integer, default: 0
    add_column :request_types, :labor_requests_count, :integer, default: 0
    add_column :request_types, :staff_requests_count, :integer, default: 0
    
    add_column :review_statuses, :contractor_requests_count, :integer, default: 0
    add_column :review_statuses, :labor_requests_count, :integer, default: 0
    add_column :review_statuses, :staff_requests_count, :integer, default: 0
  end
end
