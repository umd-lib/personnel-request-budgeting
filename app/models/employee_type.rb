# A type of employee (C1, C2, Fac, GA, etc.)
class EmployeeType < ActiveRecord::Base
  belongs_to :employee_category
end
