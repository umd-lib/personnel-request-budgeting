# A type of role (Admin, Division, Department, etc.)
class RoleType < ActiveRecord::Base
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  has_many :roles, dependent: :restrict_with_exception
  has_one :role_cutoff, dependent: :restrict_with_exception

  # Provides a short human-readable description for this record, for GUI prompts
  alias_attribute :description, :name

  def self.policy_class
    AdminOnlyPolicy
  end

  # Convenience method that returns true if the current object can be deleted
  # (i.e. has no dependent records), false otherwise.
  def allow_delete?
    roles.empty?
  end
end
