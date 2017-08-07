class RequestPolicy < ApplicationPolicy
  def create?
    true
  end

  def new?
    create?
  end

  def show?
    @user.admin? ||
      @user.active_organizations.map(&:id).include?(@record.organization_id)
  end

  def edit?
    return false if @record.archived_proxy?
    return true if @user.admin? || !@record.cutoff?
    @user.active_organizations.map(&:id).include?(@record.organization_id)
  end

  def update?
    create?
  end

  def deleted?
    edit?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(organization_id: user.all_organizations)
      end
    end
  end
end
