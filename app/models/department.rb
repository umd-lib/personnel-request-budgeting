# A department within a library division
class Department < ActiveRecord::Base
  belongs_to :division
  has_many :units, dependent: :restrict_with_exception
  has_many :contractor_requests, dependent: :restrict_with_exception
  has_many :labor_requests, dependent: :restrict_with_exception
  has_many :staff_requests, dependent: :restrict_with_exception
  has_many :roles, dependent: :restrict_with_exception
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :division_id, presence: true

  # Provide human-readable description the delete confirmation prompt
  alias_attribute :description, :name

  def self.policy_class
    AdminOnlyPolicy
  end

  # Convenience method that returns true if the current object can be deleted
  # (i.e. has no dependent records), false otherwise.
  def allow_delete?
    units.empty? && contractor_requests.empty? &&
      labor_requests.empty? && staff_requests.empty?
  end
end
