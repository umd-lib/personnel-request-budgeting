# Policy that only allows users with Admin role to perform any function
class ImpersonatePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  # rubocop:disable Style/NilComparison
  def create?
    # Using (record == nil) instead of record.nil? because the
    # ImpersonatedUser delegate always returns true for .nil?
    user.admin? && !(record == nil) && !record.admin? && (record != user)
  end
  # rubocop:enable Style/NilComparison

  def destroy?
    # Anyone can call destroy
    true
  end
end
