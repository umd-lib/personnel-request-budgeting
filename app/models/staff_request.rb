# A Regular Staff/GA staffing request
class StaffRequest < ActiveRecord::Base
  VALID_EMPLOYEE_CATEGORY_CODE = 'Reg/GA'.freeze
  VALID_REQUEST_TYPE_CODES = %w(New ConvertCont PayAdj).freeze

  include Requestable

  validates :annual_base_pay, presence: true

  FIELDS = {
    position_description: { label: 'Position Description' },
    employee_type__code: { label: 'Employee Type' },
    request_type__code: { label: 'Request Type' },
    annual_base_pay: {  label: 'Annual Base Pay',
                        decorator: :number_to_currency },
    nonop_funds: {  label: 'Nonop Funds',
                    decorator: :number_to_currency },
    division__code: { label: 'Division' },
    department__code: { label: 'Department' },
    unit__code: { label: 'Unit' },
    review_status__name: { label: 'Review Status',
                           decorator: :suppress_status }
  }.freeze

  after_initialize :init

  def init
    self.review_status ||= ReviewStatus.find_by_code('UnderReview')
  end

  # Validates the request type
  def allowed_request_type
    unless VALID_REQUEST_TYPE_CODES.include?(request_type.try(:code))
      errors.add(:request_type, 'provided is not allowed for this request.')
    end
  end

  def self.fields
    FIELDS
  end
end
