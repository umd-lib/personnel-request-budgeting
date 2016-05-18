class LaborRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Admin scope
#      scope
      # Division scope
#      user_divisions = user.divisions
#      scope.includes(:department).where(departments: { division_id: user_divisions })
      # Department scope
      user_departments = user.departments
      scope.includes(:department).where(departments: { id: user_departments })
      # Unit scope
#      user_units = user.units
#      scope.includes(:unit).where(units: { id: user_units })
   end
  end
end
