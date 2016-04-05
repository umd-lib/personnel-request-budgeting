class CreateContractorRequests < ActiveRecord::Migration
  def change
    create_table :contractor_requests do |t|
      t.references :employee_type, index: true, foreign_key: true
      t.string :position_description
      t.references :request_type, index: true, foreign_key: true
      t.string :contractor_name
      t.integer :number_of_months
      t.decimal :annual_base_pay
      t.decimal :nonop_funds
      t.string :nonop_source
      t.references :department, index: true, foreign_key: true
      t.references :subdepartment, index: true, foreign_key: true
      t.text :justification

      t.timestamps null: false
    end
  end
end
