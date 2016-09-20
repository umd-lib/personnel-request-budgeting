# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module PersonnelRequestController
  # Sets the @selectable_units and @selectable_department variables for the
  # given personnel request and current user.
  #
  # personnel_request: The personnel request shown in the GUI.
  def assign_selectable_departments_and_units(personnel_request)
    @selectable_units = policy(personnel_request).selectable_units(@current_user).sort_by(&:name)
    @selectable_departments = policy(personnel_request).selectable_departments(@current_user).sort_by(&:name)
  end
end
