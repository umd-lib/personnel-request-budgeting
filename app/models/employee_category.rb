# A category of employee ("L&A", "Regular Staff/GA", "Salaried Contractor", etc.)
class EmployeeCategory < ActiveRecord::Base
  has_many :employee_types
  validates :code, presence: true
  validates :name, presence: true
end
