# Policy for Personnel Request actions
# rubocop:disable Metrics/ClassLength
class PersonnelRequestPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    show_allowed_by_role?(user, record)
  end

  def create?
    create_allowed_by_role?(user, record)
  end

  def new?
    new_allowed_by_role?(user)
  end

  def update?
    update_allowed_by_role?(user, record)
  end

  def destroy?
    destroy_allowed_by_role?(user, record)
  end

  # Returns an array of Departments in the division
  #
  # division - the Division to return the departments of
  def self.departments_in_division(division)
    division.departments
  end

  # Returns an array of attributes added for admin users for mass assignement
  def permitted_attributes
    user.admin? ? %i( review_status_id review_comment ) : []
  end

  # Returns an array of Divisions the user's roles allow access to.
  #
  # user - the User to return the divisions of
  def self.allowed_divisions(user)
    user.roles.map(&:division).compact.uniq
  end

  # Returns an array of Units the user's roles allow access to
  def self.allowed_units(user)
    user.roles.map(&:unit).compact.uniq
  end

  # Returns an array of Departments the user's roles allow access to.
  # This includes departments the user can see because of a Division role,
  # but does NOT include departments from Unit roles (because the user is
  # only allowed to see the entries for that unit, not the whole department.
  def self.allowed_departments(user)
    departments = user.roles.map(&:department).compact.uniq
    departments += allowed_divisions(user).map(&:departments).flatten
    departments.compact.uniq
  end

  # Returns an array of Units that a user's roles allows them to set in the
  # GUI, or an empty array.
  #
  # This method takes into account role cutoffs.
  # rubocop:disable Metrics/AbcSize
  def selectable_departments(user)
    return Department.all.to_a if user.admin?

    depts = department_edit_allowed? ? user.roles.map(&:department).compact.uniq : []
    depts += division_edit_allowed? ? PersonnelRequestPolicy.allowed_divisions(user).map(&:departments).flatten : []
    depts += unit_edit_allowed? ? PersonnelRequestPolicy.allowed_units(user).map(&:department).flatten : []

    depts.compact.uniq
  end
  # rubocop:enable Metrics/AbcSize

  # Returns an array of Units that a user's roles allows them to set in the
  # GUI, or an empty array.
  #
  # This method takes into account role cutoffs.
  # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  def selectable_units(user)
    return Unit.all.to_a if user.admin?

    units = []
    depts = []
    if division_edit_allowed?
      depts += PersonnelRequestPolicy.allowed_divisions(user).map(&:departments).flatten
    end

    if department_edit_allowed?
      depts += user.roles.map(&:department).compact.uniq
      depts.each do |d|
        units += Unit.where(department: d.id).to_a
      end
    end

    unit_edit_allowed? ? (units + user.roles.map(&:unit)).compact.uniq : units
  end
  # rubocop:enable Metrics/AbcSize,Metrics/MethodLength

  # Limits the scope of returned results based on role
  class Scope < Scope
    # rubocop:disable Metrics/AbcSize
    def resolve
      # Admin always sees everything
      # Users with Division role can see everything
      return scope if user.admin? || user.division?

      return scope.none if user.roles.empty?

      scopes = allowed_departments(scope) + allowed_units(scope)

      # return the chained scopes
      scope.where(scopes.map { |s| s.arel.constraints.reduce(:and) }.reduce(:or))
    end

    # returns an array wrapped  scope of allowed departments
    def allowed_departments(scope)
      allowed_departments = PersonnelRequestPolicy.allowed_departments(user)
      allowed_departments.empty? ? [] : [scope.where(department_id: allowed_departments)]
    end

    # returns an array wrapped scope of allowed units
    def allowed_units(scope)
      allowed_units = PersonnelRequestPolicy.allowed_units(user)
      allowed_units.empty? ? [] : [scope.where(unit_id: allowed_units)]
    end
  end

  private

    # Returns true if a user is allowed to show the given record, false
    # otherwise.
    def show_allowed_by_role?(user, record)
      # no roles can see nothing
      return false if user.roles.empty?

      # Division role and admins can see all entries
      return true if user.admin? || user.division?

      # Department role can see record if in department
      allowed_departments = PersonnelRequestPolicy.allowed_departments(user)
      return true if allowed_departments.include?(record.department)

      # Unit role can see record if in unit
      allowed_units = PersonnelRequestPolicy.allowed_units(user)
      return true if allowed_units.include?(record.unit)

      false
    end

    # Returns true if a user is allowed to create the given record, false
    # otherwise.
    def create_allowed_by_role?(user, record)
      update_allowed_by_role?(user, record)
    end

    # Returns true if a user is allowed to generate new records, false
    # otherwise.

    def new_allowed_by_role?(user) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return false if user.roles.empty?

      return true if user.admin?

      return true if division_edit_allowed? && user.division?

      return true if department_edit_allowed? && user.department?

      return true if unit_edit_allowed? && user.unit?

      false
    end

    # Returns true if a user is allowed to edit the given record, false
    # otherwise.
    def update_allowed_by_role?(user, record) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      return false if user.roles.empty?

      return true if user.admin?

      return true if division_edit_allowed? && user.division? &&
                     PersonnelRequestPolicy.allowed_divisions(user).include?(record.department.division)

      return true if department_edit_allowed? && user.department? &&
                     PersonnelRequestPolicy.allowed_departments(user).include?(record.department)

      return true if unit_edit_allowed? && user.unit? &&
                     PersonnelRequestPolicy.allowed_units(user).include?(record.unit)

      false
    end

    # Returns true if a user is allowed to destroy the given record, false
    # otherwise.
    def destroy_allowed_by_role?(user, record)
      update_allowed_by_role?(user, record)
    end

    # Returns true if unit edits are allowed, false otherwise.
    #
    # This method checks against current date against the unit role cutoff date,
    # if one exists.
    def unit_edit_allowed?
      role_cutoffs['unit'] ? (today < role_cutoffs['unit']) : false
    end

    # Returns true if department edits are allowed, false otherwise.
    #
    # This method checks against current date against the department role cutoff
    # date, if one exists.
    def department_edit_allowed?
      role_cutoffs['department'] ? (today < role_cutoffs['department']) : false
    end

    # Returns true if division edits are allowed, false otherwise.
    #
    # This method checks against current date against the division role cutoff
    # date, if one exists.
    def division_edit_allowed?
      role_cutoffs['division'] ? (today < role_cutoffs['division']) : false
    end

    # Returns the current date
    def today
      Time.zone.today
    end
end
