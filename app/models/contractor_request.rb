# A Salaried Contractor staffing request
class ContractorRequest < ActiveRecord::Base
  VALID_EMPLOYEE_CATEGORY_CODE = 'SC'.freeze
  VALID_REQUEST_TYPE_CODES = %w(ConvertC1 New Renewal).freeze

  include Requestable

  validates :contractor_name, presence: true, if: :contractor_name_required?
  validates :number_of_months, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :annual_base_pay, presence: true
  validates_with RequestDepartmentValidator

  after_initialize :init

  # Provides a short human-readable description for this record, for GUI prompts
  alias_attribute :description, :position_description

  def init
    self.review_status ||= ReviewStatus.find_by_code('UnderReview')
  end

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
