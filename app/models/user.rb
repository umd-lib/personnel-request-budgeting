# A user of the application
class User < ActiveRecord::Base
  has_many :roles, dependent: :destroy
  has_many :role_types, through: :roles
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
    role_types.any? { |role_type| role_type.code == role_type_code }
  end
end
