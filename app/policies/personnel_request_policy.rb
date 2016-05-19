class PersonnelRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        # Admin always sees everything
        return scope
      end

      union_performed = false
      union_results = scope.none
      # Division scope
      user_divisions = user.divisions
      division_results = scope.none
      unless user_divisions.empty?
      end

      # Department scope
      user_departments = user.departments
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
      user_units = user.units
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
        union_results = union_results.joins("LEFT OUTER JOIN departments on departments.id = #{scope_table_name}.department_id")
        union_results = union_results.joins("LEFT OUTER JOIN units on units.id = #{scope_table_name}.unit_id")
        union_results = union_results.joins("LEFT OUTER JOIN employee_types on employee_types.id = #{scope_table_name}.employee_type_id")
        union_results = union_results.joins("LEFT OUTER JOIN request_types on request_types.id = #{scope_table_name}.request_type_id")
      end
      union_results
   end
  end
end
