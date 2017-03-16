class AddFiscalRollover < ActiveRecord::Migration
  def change

    %w( contractor_requests staff_requests labor_requests ).each do |table|
      execute "CREATE TABLE archived_#{table} AS  SELECT * FROM #{table} WHERE 1=2"
      add_column "archived_#{table}".intern, :fiscal_year, :string
      
      %i( employee_types review_statuses request_types divisions departments units  ).each do |m| 
        add_column m, "archived_#{table}_count".intern, :integer
      end

    end
    
  end
end
