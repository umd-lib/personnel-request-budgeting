# rubocop:disable Metrics/ClassLength

# Policy for Personnel Request actions
class PersonnelRequestPolicy < ApplicationPolicy
  # @return [Boolean] true if a user is allowed to see a list of personnel
  #   requests, false otherwise.
  def index?
    true
  end

  # @return [Boolean] true if the user is allowed to view a particular personnel
  #   request, false otherwise.
  def show?
    show_allowed_by_role?(user, record)
  end

  # @return [Boolean] true if the user is allowed to create a particular
  #   personnel request, false otherwise.
  def create?
    create_allowed_by_role?(user, record)
  end

  # @return [Boolean] true if the user is allowed to create a new
  #   personnel request, false otherwise.
  def new?
    new_allowed_by_role?(user)
  end

  # @return [Boolean] true if the user is allowed to update a particular
  #   personnel request, false otherwise.
  def update?
    update_allowed_by_role?(user, record)
  end

  # @return [Boolean] true if the user is allowed to delete a particular
  #   personnel request, false otherwise.
  def destroy?
    destroy_allowed_by_role?(user, record)
  end

  # @param division [Division] the division to return the departments of
  # @return [ActiveRecord::Relation<Department>] an ActiveRecord::Relation
  #   containing the departments in the given division.
  def self.departments_in_division(division)
    division.departments
  end

  # @return [Array<Symbol>] an Array of symbols representing attributes
  #   permitted for mass assignment
  def permitted_attributes
    user.admin? ? %i(review_status_id review_comment) : []
  end

  # @param user [User] the User to return the divisions of
  # @return [Array<Division>] an array of Divisions the user's roles allow
  #   access to. Array will be empty if the user does not have any Division
  #   roles.
  # @note Only returns divisions based on the "Division" roles a user has.
  #   For a user with an "Admin" role, this method will return an empty array.
  def self.allowed_divisions(user)
    user.roles.map(&:division).compact.uniq
  end

  # @param user [User] the User to return the units of
  # @return [Array<Unit>] an array of Units the user's roles allow
  #   access to. Array will be empty if the user does not have any Unit
  #   roles.
  # @note Only returns units based on the "Unit" roles a user has. For a user
  #   with an "Admin" role, this method will return an empty array.
  def self.allowed_units(user)
    user.roles.map(&:unit).compact.uniq
  end

  # Returns an array of Departments the user's roles allow access to.
  # This includes departments the user can see because of a Division role,
  # but does **not** include departments from Unit roles (because the user is
  # only allowed to see the entries for that unit, not the whole department.
  #
  # @param user [User] the User to return the departments of
  # @return [Array<Deparment>] an array of Departments the user's roles allow
  #   access to. This includes departments the user can see because of a
  #   Division role, but does **not** include departments from Unit roles
  #   (because the user is only allowed to see the entries for that unit,
  #   not the whole department). Array will be empty if the user does not have
  #   any Department or Division roles.
  # @note Only returns departments based on the "Department" or "Division" roles
  #   a user has. For a user with an "Admin" role, this method will return an
  #   empty array.
  def self.allowed_departments(user)
    departments = user.roles.map(&:department).compact.uniq
    departments += allowed_divisions(user).map(&:departments).flatten
    departments.compact.uniq
  end

  # rubocop:disable Metrics/AbcSize

  # @return [Array<Department>] the departments a user's roles allows them to
  #   set in the GUI, or an empty array.
  # @note This method takes into account role cutoffs.
  def selectable_departments(user)
    return Department.all.to_a if user.admin?

    depts = department_edit_allowed? ? user.roles.map(&:department).compact.uniq : []
    depts += division_edit_allowed? ? PersonnelRequestPolicy.allowed_divisions(user).map(&:departments).flatten : []
    depts += unit_edit_allowed? ? PersonnelRequestPolicy.allowed_units(user).map(&:department).flatten : []

    depts.compact.uniq
  end

  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize,Metrics/MethodLength

  # @return [Array<Unit>] the units a user's roles allows them to set in the
  #   GUI, or an empty array.
  # @note This method takes into account role cutoffs.
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

    # @return [ActiveRecord::Relation] the ActiveRecord::Relation containing
    #   the personnel requests the current user is allowed to see.
    def resolve
      # Admin always sees everything
      # Users with Division role can see everything
      return scope if user.admin? || user.division?

      return scope.none if user.roles.empty?

      scopes = allowed_departments(scope) + allowed_units(scope)

      # return the chained scopes
      scope.where(scopes.map { |s| s.arel.constraints.reduce(:and) }.reduce(:or))
    end

    # @return [Array<Department>] the departments a user's roles allows them to
    #   see, or an empty array.
    def allowed_departments(scope)
      allowed_departments = PersonnelRequestPolicy.allowed_departments(user)
      allowed_departments.empty? ? [] : [scope.where(department_id: allowed_departments)]
    end

    # @return [Array<Unit>] the units a user's roles allows them to
    #   see, or an empty array.
    def allowed_units(scope)
      allowed_units = PersonnelRequestPolicy.allowed_units(user)
      allowed_units.empty? ? [] : [scope.where(unit_id: allowed_units)]
    end
  end

  private

    # @return [Boolean] true if a user is allowed to show the given record,
    #   false otherwise.
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

    # @return [Boolean] true if a user is allowed to create the given record, false
    #   otherwise.
    def create_allowed_by_role?(user, record)
      update_allowed_by_role?(user, record)
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # @return [Boolean] true if a user is allowed to generate new records, false
    #   otherwise.
    def new_allowed_by_role?(user)
      return false if user.roles.empty?

      return true if user.admin?

      return true if division_edit_allowed? && user.division?

      return true if department_edit_allowed? && user.department?

      return true if unit_edit_allowed? && user.unit?

      false
    end

    # @return [Boolean] true if a user is allowed to edit the given record,
    #   false otherwise.
    def update_allowed_by_role?(user, record)
      return false if user.roles.empty?

      return true if user.admin?

      # only check for inclusion in the allowed divisions if there is a
      # department in the request record; otherwise, return true and let the
      # validation process catch the "no department" error
      return true if division_edit_allowed? && user.division? && (!record.department ||
                     PersonnelRequestPolicy.allowed_divisions(user).include?(record.department.division))

      return true if department_edit_allowed? && user.department? &&
                     PersonnelRequestPolicy.allowed_departments(user).include?(record.department)

      return true if unit_edit_allowed? && user.unit? &&
                     PersonnelRequestPolicy.allowed_units(user).include?(record.unit)

      check_dept_and_unit(user, record) if record.new_record?

      false
    end

    # @return [void]
    def check_dept_and_unit(user, record)
      if !record.department.nil? && !PersonnelRequestPolicy.allowed_departments(user).include?(record.department)
        raise Pundit::NotAuthorizedDepartmentError, record: record, policy: self
      end

      if !record.unit.nil? && !PersonnelRequestPolicy.allowed_unitss(user).include?(record.unit)
        raise Pundit::NotAuthorizedUnitError, record: record, policy: self
      end
      true
    end

    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # @return [Boolean] true if a user is allowed to destroy the given record,
    #   false otherwise.
    def destroy_allowed_by_role?(user, record)
      update_allowed_by_role?(user, record)
    end

    # @return [Boolean] true if unit edits are allowed, false otherwise.
    # @note This method takes into account role cutoffs.
    def unit_edit_allowed?
      role_cutoffs['unit'] ? (today < role_cutoffs['unit']) : false
    end

    # @return [Boolean] true if department edits are allowed, false otherwise.
    # @note This method takes into account role cutoffs.
    def department_edit_allowed?
      role_cutoffs['department'] ? (today < role_cutoffs['department']) : false
    end

    # @return [Boolean] true if division edits are allowed, false otherwise.
    # @note This method takes into account role cutoffs.
    def division_edit_allowed?
      role_cutoffs['division'] ? (today < role_cutoffs['division']) : false
    end

    # @return [Date] the current date
    def today
      Time.zone.today
    end
end
