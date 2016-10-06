# A category of employee ("L&A", "Regular Staff/GA", "Salaried Contractor", etc.)
class EmployeeCategory < ActiveRecord::Base
  has_many :employee_types, dependent: :restrict_with_exception
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # Provide human-readable description the delete confirmation prompt
  alias_attribute :description, :name

  def self.policy_class
    AdminOnlyPolicy
  end

  # Convenience method that returns true if the current object can be deleted
  # (i.e. has no dependent records), false otherwise.
  def allow_delete?
    employee_types.empty?
  end
end
