# A Regular Staff/GA staffing request
class StaffRequest < ActiveRecord::Base
  VALID_EMPLOYEE_CATEGORY_CODE = 'Reg/GA'.freeze
  VALID_REQUEST_TYPE_CODES = %w(New ConvertCont PayAdj).freeze

  include Requestable

  validates :annual_base_pay, presence: true

  after_initialize :init

  # Provides a short human-readable description for this record, for GUI prompts
  alias_attribute :description, :position_description

  def init
    self.review_status ||= ReviewStatus.find_by_code('UnderReview')
  end

  # Validates the request type
  def allowed_request_type
    unless VALID_REQUEST_TYPE_CODES.include?(request_type.try(:code))
      errors.add(:request_type, 'provided is not allowed for this request.')
    end
  end
end
