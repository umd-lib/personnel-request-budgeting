class CreateReviewStatuses < ActiveRecord::Migration
  def change
    create_table :review_statuses do |t|
      t.string :name
      t.string :color, :default => "#ffffff"
      t.timestamps null: false
    end
  end
end
