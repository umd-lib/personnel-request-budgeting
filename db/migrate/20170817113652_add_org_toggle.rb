class AddOrgToggle < ActiveRecord::Migration

  def change
    add_column :organizations, :deactivated, :boolean, default: false
    add_index :organizations, [ :organization_type, :code ], unique: true
	end
end
