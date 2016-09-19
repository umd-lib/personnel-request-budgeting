# Default superclass for Pundit Policy classes
class ApplicationPolicy
  attr_reader :user, :record, :role_cutoffs

  def initialize(user, record)
    @user = user
    @record = record
    @role_cutoffs = RoleCutoff.eager_load(:role_type).all.each_with_object({}) do |rc, memo|
      memo[rc.role_type.code] = rc.cutoff_date
      memo
    end.freeze
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  # Sets the initial scope of results to return
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
