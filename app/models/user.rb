# A user of the application
class User < ActiveRecord::Base
  has_many :roles, dependent: :restrict_with_exception
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def self.policy_class
    AdminOnlyPolicy
  end

  # Returns true if the current user is an admin, false otherwise.
  def admin?
    Role.where(user: self).where(role_type: RoleType.find_by_code('admin')).any?
  end
end
