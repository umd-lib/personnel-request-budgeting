# Validates the department and subdepartment entries on requests
class RequestDepartmentValidator < ActiveModel::Validator
  def validate(record)
    department_exists(record)
    subdepartment_matches_department(record)
  end

  # Validates the department
  def department_exists(record)
    record.errors.add(:department_id, 'provided does not exist') unless Department.find_by_id(record.department_id)
  end

  # Validates that the subdepartment matches the department
  def subdepartment_matches_department(record)
    subdepartment = Subdepartment.find_by_id(record.subdepartment_id)
    if subdepartment
      department = Department.find_by_id(record.department_id)
      unless department && (department.id == subdepartment.department_id)
        record.errors.add(:subdepartment_id, 'provided does not belong to department')
      end
    end
  end
end
