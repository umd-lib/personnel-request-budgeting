# A category of employee ("L&A", "Regular Staff/GA", "Salaried Contractor", etc.)
class EmployeeCategory < ActiveRecord::Base
  has_many :employee_types
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
