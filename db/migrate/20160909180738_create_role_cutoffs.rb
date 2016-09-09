class CreateRoleCutoffs < ActiveRecord::Migration
  def change
    create_table :role_cutoffs do |t|
      t.references :role_type, index: true, foreign_key: true
      t.date :cutoff_date

      t.timestamps null: false
    end
  end
end
