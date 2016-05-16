class AddIndicesToUniqueDataFields < ActiveRecord::Migration
  def change
    add_index :departments, :code, unique: true
    add_index :divisions, :code, unique: true
    add_index :employee_categories, :code, unique: true
    add_index :employee_types, :code, unique: true
    add_index :request_types, :code, unique: true
    add_index :units, :code, unique: true
    add_index :users, :cas_directory_id, unique: true
  end
end
