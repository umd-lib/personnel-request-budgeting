# A type of role (Admin, Division, Department, etc.)
class RoleType < ActiveRecord::Base
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  has_many :roles, dependent: :restrict_with_exception

  # Convenience method that returns true if the current object can be deleted
  # (i.e. has no dependent records), false otherwise.
  def allow_delete?
    roles.empty?
  end
end
