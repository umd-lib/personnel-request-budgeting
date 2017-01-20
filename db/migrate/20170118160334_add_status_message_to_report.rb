class AddStatusMessageToReport < ActiveRecord::Migration
  def change
    add_column :reports, :status_message, :string
  end
end
