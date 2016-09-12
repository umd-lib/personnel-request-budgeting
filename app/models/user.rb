# A user of the application
class User < ActiveRecord::Base
  has_many :roles, dependent: :restrict_with_exception
  validates :cas_directory_id, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # Returns true if this user has an Admin role, false otherwise.
  def admin?
    role?('admin')
  end

  # Returns true if this user has a Division role, false otherwise.
  def division?
    role?('division')
  end

  # Returns true if this user has a Department role, false otherwise.
  def department?
    role?('department')
  end

  # Returns true if this user has a Unit role, false otherwise.
  def unit?
    role?('unit')
  end

  # Returns true if this user as a role with the given code, false otherwise.
  #
  # - role_type_code - a String representing the role type code
  def role?(role_type_code)
    roles(RoleType.find_by_code(role_type_code)).any?
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
