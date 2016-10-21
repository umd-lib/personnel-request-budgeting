class ChangePositionDescriptionToTitle < ActiveRecord::Migration
  def change
    change_table :contractor_requests do |t|
      t.rename :position_description, :position_title
    end
    change_table :labor_requests do |t|
      t.rename :position_description, :position_title
    end
    change_table :staff_requests do |t|
      t.rename :position_description, :position_title
    end
  end
end
