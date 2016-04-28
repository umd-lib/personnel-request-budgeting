class RenameSubdepartmentToUnit < ActiveRecord::Migration
  def self.up
    rename_table :subdepartments, :units
  end

  def self.down
    rename_table :units, :subdepartments
  end
end
