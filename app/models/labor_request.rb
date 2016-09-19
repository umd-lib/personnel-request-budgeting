# A Labor and Assistance staffing request
class LaborRequest < ActiveRecord::Base
  belongs_to :employee_type
  belongs_to :request_type
  belongs_to :department
  belongs_to :unit
  belongs_to :review_status
  has_one :division, through: :department, autosave: false

  validates :employee_type, presence: true
  validates :position_description, presence: true
  validates :request_type, presence: true
  validates :contractor_name, presence: true, if: :contractor_name_required?
  validates :number_of_positions, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :hourly_rate, presence: true, numericality: { greater_than: 0.00 }
  validates :hours_per_week, presence: true, numericality: { greater_than: 0.00 }
  validates :number_of_weeks, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :department_id, presence: true
  validates_with RequestDepartmentValidator

  VALID_EMPLOYEE_CATEGORY_CODE = 'L&A'.freeze
  validates_with RequestEmployeeTypeValidator, valid_employee_category_code: VALID_EMPLOYEE_CATEGORY_CODE

  VALID_REQUEST_TYPE_CODES = %w(New Renewal).freeze
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
