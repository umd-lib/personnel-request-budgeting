# A Salaried Contractor staffing request
class ContractorRequest < ActiveRecord::Base
  VALID_EMPLOYEE_CATEGORY_CODE = 'SC'.freeze
  VALID_REQUEST_TYPE_CODES = %w(ConvertC1 New Renewal).freeze

  include Requestable

  belongs_to :department, counter_cache: true
  belongs_to :unit, counter_cache: true
  belongs_to :employee_type, counter_cache: true
  belongs_to :request_type, counter_cache: true
  belongs_to :review_status, counter_cache: true

  validates :contractor_name, presence: true, if: :contractor_name_required?
  validates :number_of_months, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :justification, presence: true
  validates_with RequestDepartmentValidator

  monetize :annual_base_pay_cents, presence: false, numericality: { greater_than: 0.00 }

  # Provides a short human-readable description for this record, for GUI prompts
  alias_attribute :description, :position_title

  # Validates the request type
  def allowed_request_type
    return if VALID_REQUEST_TYPE_CODES.include?(request_type.try(:code))
    errors.add(:request_type, 'Not an allowed request type for this request.')
  end

  # Returns true if the contractor name is required.
  def contractor_name_required?
    request_type.try(:code) == 'Renewal'
  end
end
