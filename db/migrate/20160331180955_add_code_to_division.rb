class AddCodeToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :code, :string
  end
end
