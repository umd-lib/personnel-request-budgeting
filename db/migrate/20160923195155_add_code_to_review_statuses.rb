class AddCodeToReviewStatuses < ActiveRecord::Migration
  def change
    add_column :review_statuses, :code, :string
  end
end
