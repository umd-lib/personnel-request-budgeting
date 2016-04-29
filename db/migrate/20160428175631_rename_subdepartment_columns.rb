class RenameSubdepartmentColumns < ActiveRecord::Migration
  def change
    rename_column :contractor_requests, :subdepartment_id, :unit_id
    rename_column :labor_requests, :subdepartment_id, :unit_id
    rename_column :staff_requests, :subdepartment_id, :unit_id
  end
end
