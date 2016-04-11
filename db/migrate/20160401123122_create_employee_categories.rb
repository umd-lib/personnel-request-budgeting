class CreateEmployeeCategories < ActiveRecord::Migration
  def change
    create_table :employee_categories do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
