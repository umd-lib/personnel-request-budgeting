# Validates the department and unit entries on requests
class RequestDepartmentValidator < ActiveModel::Validator
  def validate(record)
    department_exists(record)
    unit_matches_department(record)
  end

  # Validates the department
  def department_exists(record)
    record.errors.add(:department_id, 'provided does not exist') unless Department.find_by(id: record.department_id)
  end

  # Validates that the unit matches the department
  def unit_matches_department(record)
    unit = Unit.find_by(id: record.unit_id)
    return unless unit

    department = Department.find_by(id: record.department_id)
    return if  department && (department.id == unit.department_id)

    record.errors.add(:unit_id, 'provided does not belong to department')
  end
end
