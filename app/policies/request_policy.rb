class RequestPolicy < ApplicationPolicy
  def create?
    true
  end

  def new?
    create?
  end

  def show?
    @user.admin? || @user.all_organizations.map(&:id).include?(@record.organization_id)
  end

  def edit?
    return false if @record.archived_proxy?
    return true if @user.admin?
    return false if @record.cutoff?
    @user.active_organizations.map(&:id).include?(@record.organization_id)
  end

  def update?
    create?
  end

  def destroy?
    edit?
  end

  def admin_only_attributes
    @user.admin? ? %i[review_status_id review_comment] : []
  end

  def permitted_attributes
    %i[employee_type position_title request_type organization_id
       contractor_name number_of_positions hourly_rate hours_per_week
       number_of_weeks nonop_funds nonop_source department_id
       unit_id justification] + admin_only_attributes
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if @user.admin?
        scope.all
      else
        scope.where(organization_id: @user.all_organizations)
      end
    end
  end
end
