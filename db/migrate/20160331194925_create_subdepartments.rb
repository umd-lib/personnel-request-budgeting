class CreateSubdepartments < ActiveRecord::Migration
  def change
    create_table :subdepartments do |t|
      t.string :code
      t.string :name
      t.references :department, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
