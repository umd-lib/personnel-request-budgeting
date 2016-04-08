class ChangeNumOfPositionsToNumberOfPositions < ActiveRecord::Migration
  def change
    rename_column :labor_requests, :num_of_positions, :number_of_positions
  end
end
