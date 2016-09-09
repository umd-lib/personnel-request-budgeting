# Manages the date at which a particular role's edit privileges should end
class RoleCutoff < ActiveRecord::Base
  belongs_to :role_type
  validates :cutoff_date, presence: true
  validates :role_type_id, presence: true, uniqueness: true

  def self.policy_class
    AdminOnlyPolicy
  end
end
