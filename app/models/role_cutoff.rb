# Manages the date at which a particular role's edit privileges should end
class RoleCutoff < ActiveRecord::Base
  belongs_to :role_type

  validates :cutoff_date, presence: true
  validates :role_type_id, presence: true, uniqueness: true
  validate :role_type_must_not_be_admin

  def self.policy_class
    AdminOnlyPolicy
  end

  private

    # Verifies that "admin" is not given a role cutoff
    def role_type_must_not_be_admin
      errors.add(
        :role_type, "of #{role_type.name} cannot be given a cutoff date") if role_type == RoleType.find_by_code('admin')
    end
end
