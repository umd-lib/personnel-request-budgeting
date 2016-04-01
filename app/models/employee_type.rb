class EmployeeType < ActiveRecord::Base
  belongs_to :employee_category
end
