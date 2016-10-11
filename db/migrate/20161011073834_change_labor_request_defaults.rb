class ChangeLaborRequestDefaults < ActiveRecord::Migration
  def change
  
      change_column_default :labor_requests,  :number_of_weeks, 1
      change_column_default :labor_requests,  :number_of_positions, 1
  
      change_column_default :contractor_requests,  :number_of_months, 1
  
  end
end
