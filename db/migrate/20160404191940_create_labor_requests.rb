class CreateLaborRequests < ActiveRecord::Migration
  def change
    create_table :labor_requests do |t|
      t.references :employee_type, index: true, foreign_key: true
      t.string :position_description
      t.references :request_type, index: true, foreign_key: true
      t.string :contractor_name
      t.integer :num_of_positions
      t.decimal :hourly_rate
      t.decimal :hours_per_week
      t.integer :number_of_weeks
      t.decimal :nonop_funds
      t.string :nonop_source
      t.references :department, index: true, foreign_key: true
      t.references :subdepartment, index: true, foreign_key: true
      t.text :justification

      t.timestamps null: false
    end
  end
end
