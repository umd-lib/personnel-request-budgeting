# A unit within a department
class Unit < ActiveRecord::Base
  belongs_to :department, counter_cache: true

  %w(contractor labor staff).each do |r|
    has_many "#{r}_requests".intern, dependent: :restrict_with_exception
    has_many "archived_#{r}_requests".intern, dependent: :restrict_with_exception
  end

  has_many :roles, dependent: :restrict_with_exception
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :department_id, presence: true

  # Provides a short human-readable description for this record, for GUI prompts
  alias_attribute :description, :name

  def self.policy_class
    AdminOnlyPolicy
  end

  # Convenience method that returns true if the current object can be deleted
  # (i.e. has no dependent records), false otherwise.
  def allow_delete?
    contractor_requests.empty? && labor_requests.empty? && staff_requests.empty?
  end
end
