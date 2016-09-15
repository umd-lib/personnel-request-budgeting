class AddReviewStatusesToRecords < ActiveRecord::Migration
  def change
    %i{ contractor_requests labor_requests staff_requests }.each do |table|
      change_table(table) do |t|
        t.belongs_to :review_status
        t.text :review_comment
      end
    end
  
  end
end
