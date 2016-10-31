# A Regular Staff/GA staffing request
class StaffRequest < ActiveRecord::Base
  VALID_EMPLOYEE_CATEGORY_CODE = 'Reg/GA'.freeze
  VALID_REQUEST_TYPE_CODES = %w(New ConvertCont PayAdj).freeze

  include Requestable

  belongs_to :department, counter_cache: true
  belongs_to :unit, counter_cache: true
  belongs_to :employee_type, counter_cache: true
  belongs_to :request_type, counter_cache: true
  belongs_to :review_status, counter_cache: true

  validates :annual_base_pay, presence: true
  validates :employee_name, presence: true, if: :employee_name_required?

  # Provides a short human-readable description for this record, for GUI prompts
  alias_attribute :description, :position_title

  # Validates the request type
  def allowed_request_type
    return if VALID_REQUEST_TYPE_CODES.include?(request_type.try(:code))
    errors.add(:request_type, 'provided is not allowed for this request.')
  end

  # Returns true if the employee name is required.
  def employee_name_required?
    request_type.try(:code) == 'PayAdj'
  end
end
