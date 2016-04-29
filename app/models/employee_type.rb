# A type of employee (C1, C2, Fac, GA, etc.)
class EmployeeType < ActiveRecord::Base
  belongs_to :employee_category
  has_many :contractor_requests, dependent: :restrict_with_exception
  has_many :labor_requests, dependent: :restrict_with_exception
  has_many :staff_requests, dependent: :restrict_with_exception
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :employee_category, presence: true

  # Returns an ActiveRecord::Relation of employee types with the given
  # employee category code
  def self.employee_types_with_category(employee_category_code)
    EmployeeType.joins(:employee_category).where(
      'employee_categories.code=?', employee_category_code)
  end

  # Convenience method that returns true if the current object can be deleted
  # (i.e. has no dependent records), false otherwise.
  def allow_delete?
    contractor_requests.empty? && labor_requests.empty? && staff_requests.empty?
  end
end
