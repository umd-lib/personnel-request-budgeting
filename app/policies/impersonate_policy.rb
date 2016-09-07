# Policy that only allows users with Admin role to perform any function
class ImpersonatePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    # Anyone can call destroy
    true
  end
end
