# A type of employee (C1, C2, Fac, GA, etc.)
class EmployeeType < ActiveRecord::Base
  belongs_to :employee_category, counter_cache: true

  %w(contractor labor staff).each do |r|
    has_many "#{r}_requests".intern, dependent: :restrict_with_exception
    has_many "archived_#{r}_requests".intern, dependent: :restrict_with_exception
  end

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :employee_category, presence: true

  # Provides a short human-readable description for this record, for GUI prompts
  alias_attribute :description, :name

  def self.policy_class
    AdminOnlyPolicy
  end

  # Returns an ActiveRecord::Relation of employee types with the given
  # employee category code
  def self.employee_types_with_category(employee_category_code)
    EmployeeType.joins(:employee_category).where(
      'employee_categories.code=?', employee_category_code
    )
  end

  # Convenience method that returns true if the current object can be deleted
  # (i.e. has no dependent records), false otherwise.
  def allow_delete?
    contractor_requests.empty? && labor_requests.empty? && staff_requests.empty?
  end
end
