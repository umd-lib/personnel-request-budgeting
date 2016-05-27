# Policy for Personnel Request actions
class PersonnelRequestPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    show_allowed_by_role?(user, record)
  end

  def create?
    true
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
    Department.where(division_id: division)
  end

  # Returns an array of Departments the user's roles allow access to
  def self.allowed_departments(user)
    allowed_departments = []

    division_roles = user.roles(RoleType.find_by_code('division'))
    division_roles.each do |r|
      depts_in_division = departments_in_division(r.division)
      allowed_departments += depts_in_division
    end

    department_roles = user.roles(RoleType.find_by_code('department'))
    department_roles.each do |r|
      allowed_departments << r.department
    end

    allowed_departments.uniq
  end

  # Returns an array of Units the user's roles allow access to
  def self.allowed_units(user)
    allowed_units = []
    unit_roles = user.roles(RoleType.find_by_code('unit'))
    unit_roles.each do |r|
      allowed_units << r.unit
    end
    allowed_units
  end

  private

    # Returns true if a user is allowed to show the given record, false
    # otherwise.
    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def show_allowed_by_role?(user, record)
      return false if user.roles.empty?

      return true if user.admin?

      # Division role can see all entries
      return true if user.division?

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
    def create_allowed_by_role?
      true
    end

    # Returns true if a user is allowed to edit the given record, false
    # otherwise.
    def update_allowed_by_role?(user, record)
      return false if user.roles.empty?

      return true if user.admin?

      # Division and Department role can edit record if in department
      allowed_departments = PersonnelRequestPolicy.allowed_departments(user)
      return true if allowed_departments.include?(record.department)

      # Unit role can see record if in unit
      allowed_units = PersonnelRequestPolicy.allowed_units(user)
      return true if allowed_units.include?(record.unit)

      false
    end

    # Returns true if a user is allowed to destroy the given record, false
    # otherwise.
    def destroy_allowed_by_role?(user, record)
      return update_allowed_by_role?(user, record)
    end

  # Limits the scope of returned results based on role
  class Scope < Scope
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength,
    def resolve
      if user.admin?
        # Admin always sees everything
        return scope
      end

      # Division scope
      if user.division?
        # Users with Division role can see everything
        return scope
      end

      union_performed = false
      union_results = scope.none

      # Department scope
      user_departments = PersonnelRequestPolicy.allowed_departments(user)
      department_results = scope.none
      unless user_departments.empty?
        department_results = scope.where(department_id: user_departments)
        if department_results.any?
          if union_results.empty?
            union_results = department_results.reorder(nil)
          else
            union_results = union_results.union(department_results.reorder(nil))
            union_performed = true
          end
        end
      end

      # Unit scope
      user_units = PersonnelRequestPolicy.allowed_units(user)
      unit_results = scope.none
      unless user_units.empty?
        unit_results = scope.where(unit_id: user_units)
        if unit_results.any?
          if union_results.empty?
            union_results = unit_results.reorder(nil)
          else
            union_results = union_results.union(unit_results.reorder(nil))
            union_performed = true
          end
        end
      end

      if union_performed
        # When a union is performed, we lose the connection to the
        # associated tables. The following joins reconnects the associations
        scope_table_name = scope.table_name
        union_results = union_results.joins(
          "LEFT OUTER JOIN departments on departments.id = #{scope_table_name}.department_id")
        union_results = union_results.joins(
          "LEFT OUTER JOIN units on units.id = #{scope_table_name}.unit_id")
        union_results = union_results.joins(
          "LEFT OUTER JOIN employee_types on employee_types.id = #{scope_table_name}.employee_type_id")
        union_results = union_results.joins(
          "LEFT OUTER JOIN request_types on request_types.id = #{scope_table_name}.request_type_id")
      end
      union_results
    end
  end
end
