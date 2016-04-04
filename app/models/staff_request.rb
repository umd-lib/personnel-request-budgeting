# A Regular Staff/GA personnel request
class StaffRequest < ActiveRecord::Base
  belongs_to :employee_type
  belongs_to :request_type
  belongs_to :department
  belongs_to :subdepartment
  validates :employee_type, presence: true
  validates :position_description, presence: true
  validates :request_type, presence: true
  validates :annual_base_pay, presence: true
  validates :department_id, presence: true

  validate :allowed_employee_type
  validate :allowed_request_type
  validate :department_exists
  validate :subdepartment_matches_department

  VALID_EMPLOYEE_CATEGORY_CODE = 'Reg/GA'.freeze
  VALID_REQUEST_TYPE_CODES = %w(New ConvertCont PayAdj).freeze

  # Validates the employee type
  def allowed_employee_type
    unless valid_employee_types.include?(employee_type)
      errors.add(:employee_type, 'Not an allowed employee type for this request.')
    end
  end

  # Validates the request type
  def allowed_request_type
    unless VALID_REQUEST_TYPE_CODES.include?(request_type.try(:code))
      errors.add(:request_type, 'Not an allowed request type for this request.')
    end
  end

  # Validates the department
  def department_exists
    errors.add(:department_id, 'Department does not exist') unless Department.find_by_id(department_id)
  end

  # Validates that the subdepartment matches the department
  def subdepartment_matches_department
    subdepartment = Subdepartment.find_by_id(subdepartment_id)
    if subdepartment
      department = Department.find_by_id(department_id)
      subdepartment = Subdepartment.find_by_id(subdepartment_id)
      unless department && (department.id == subdepartment.department_id)
        errors.add(:department_id, 'Subdepartment does not belong to department')
      end
    end
  end

  # Returns an ActiveRecord::Relation of valid employee types
  def valid_employee_types
    EmployeeType.joins(:employee_category).where(
      'employee_categories.code=?', StaffRequest::VALID_EMPLOYEE_CATEGORY_CODE)
  end
end
