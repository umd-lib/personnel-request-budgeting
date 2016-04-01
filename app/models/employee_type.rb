# A type of employee (C1, C2, Fac, GA, etc.)
class EmployeeType < ActiveRecord::Base
  belongs_to :employee_category
  validates :code, presence: true
  validates :name, presence: true
  validates :employee_category, presence: true
end
