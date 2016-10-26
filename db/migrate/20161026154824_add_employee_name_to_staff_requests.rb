class AddEmployeeNameToStaffRequests < ActiveRecord::Migration
  def change
    add_column :staff_requests, :employee_name, :string
  end
end
