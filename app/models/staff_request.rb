# A Regular Staff/GA staffing request
class StaffRequest < ActiveRecord::Base
  belongs_to :employee_type
  belongs_to :request_type
  belongs_to :department
  belongs_to :unit
  validates :employee_type, presence: true
  validates :position_description, presence: true
  validates :request_type, presence: true
  validates :annual_base_pay, presence: true
  validates :department_id, presence: true
  validates_with RequestDepartmentValidator

  VALID_EMPLOYEE_CATEGORY_CODE = 'Reg/GA'.freeze
  validates_with RequestEmployeeTypeValidator, valid_employee_category_code: VALID_EMPLOYEE_CATEGORY_CODE

  VALID_REQUEST_TYPE_CODES = %w(New ConvertCont PayAdj).freeze
  validate :allowed_request_type

  # Validates the request type
  def allowed_request_type
    unless VALID_REQUEST_TYPE_CODES.include?(request_type.try(:code))
      errors.add(:request_type, 'provided is not allowed for this request.')
    end
  end
end
