class RequestPolicy < ApplicationPolicy
  def create?
    true
  end

  def new?
    create?
  end

  def show?
    @user.admin? ||
      (@user.active_organizations.map(&:id) && [@record.organization_id, @record.unit_id]).any?
  end

  def edit?
    return false if @record.archived_proxy?
    return true if @user.admin?
    return false if @record.cutoff?
    (@user.active_organizations.map(&:id) && [@record.organization_id, @record.unit_id]).any?
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
       unit_id justification spawned ] + admin_only_attributes
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @user.admin? ? @scope.all : scoped_query
    end

    private

      def scoped_query
        @scope.where(@scope.arel_table[:organization_id].in(@user.all_organizations.map(&:id))
            .or(@scope.arel_table[:unit_id].in(@user.all_organizations
            .select { |o| o.organization_type == 'unit' }.map(&:id))))
      end
  end
end
