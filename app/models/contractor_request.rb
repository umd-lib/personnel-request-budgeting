# A Salaried Contractor staffing request
class ContractorRequest < ActiveRecord::Base
  belongs_to :employee_type
  belongs_to :request_type
  belongs_to :department
  belongs_to :unit
  validates :employee_type, presence: true
  validates :position_description, presence: true
  validates :request_type, presence: true
  validates :contractor_name, presence: true, if: :contractor_name_required?
  validates :number_of_months, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :annual_base_pay, presence: true
  validates :department_id, presence: true
  validates_with RequestDepartmentValidator

  VALID_EMPLOYEE_CATEGORY_CODE = 'SC'.freeze
  validates_with RequestEmployeeTypeValidator, valid_employee_category_code: VALID_EMPLOYEE_CATEGORY_CODE

  VALID_REQUEST_TYPE_CODES = %w(ConvertC1 New Renewal).freeze
  validate :allowed_request_type

  # Validates the request type
  def allowed_request_type
    unless VALID_REQUEST_TYPE_CODES.include?(request_type.try(:code))
      errors.add(:request_type, 'Not an allowed request type for this request.')
    end
  end

  # Returns true if the contractor name is required.
  def contractor_name_required?
    request_type.try(:code) == 'Renewal'
  end
end
