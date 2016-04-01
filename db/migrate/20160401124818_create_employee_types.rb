class CreateEmployeeTypes < ActiveRecord::Migration
  def change
    create_table :employee_types do |t|
      t.string :code
      t.string :name
      t.references :employee_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
