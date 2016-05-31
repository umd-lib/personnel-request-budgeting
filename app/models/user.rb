# A user of the application
class User < ActiveRecord::Base
  has_many :roles, dependent: :restrict_with_exception
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # Returns true if this user has an Admin role, false otherwise.
  def admin?
    roles(RoleType.find_by_code('admin')).any?
  end

  # Returns true if this user has a Division role, false otherwise.
  def division?
    roles(RoleType.find_by_code('division')).any?
  end

  # Returns an array of Roles for this user. Can optionally specify the RoleType
  # of roles to return.
  #
  # If the user has no roles, an empty array is returned.
  def roles(role_type = nil)
    return Role.where(user: self).to_ary if role_type.nil?

    Role.where(user: self).where(role_type: role_type).to_ary
  end
end
