class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.references :user, index: true, foreign_key: true
      t.references :role_type, index: true, foreign_key: true
      t.references :division, index: true, foreign_key: true
      t.references :department, index: true, foreign_key: true
      t.references :unit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
