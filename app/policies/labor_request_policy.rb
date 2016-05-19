class LaborRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Admin scope
#      scope
      # Division scope
#      user_divisions = user.divisions
#      scope.includes(:department).where(departments: { division_id: user_divisions })
      # Department scope
#      user_departments = user.departments
#      scope.includes(:department).where(departments: { id: user_departments })
      # Unit scope
#      user_units = user.units
#      scope.includes(:unit).where(units: { id: user_units })

      # Division scope
#      user_divisions = user.divisions
#      scope.includes(:department).where(departments: { division_id: user_divisions })

      # Department scope
      user_departments = user.departments
      department_results = scope.where(department_id: user_departments)
      # Unit scope
      user_units = user.units
      unit_results = scope.where(unit_id: user_units)

      union_results = department_results.reorder(nil).union(unit_results.reorder(nil))

      scope_table_name = scope.table_name
      join1_results = union_results.joins("LEFT OUTER JOIN departments on departments.id = #{scope_table_name}.department_id")
      join2_results = join1_results.joins("LEFT OUTER JOIN units on units.id = #{scope_table_name}.unit_id")
      join3_results = join2_results.joins("LEFT OUTER JOIN employee_types on employee_types.id = #{scope_table_name}.employee_type_id")
      join4_results = join3_results.joins("LEFT OUTER JOIN request_types on request_types.id = #{scope_table_name}.request_type_id")
      join4_results
#      dept_union_results = union_results.joins("LEFT OUTER JOIN departments on departments.id = labor_requests.department_id")
   end
  end
end
