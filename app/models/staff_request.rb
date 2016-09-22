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
                        decorator: -> (view, obj, ac) { view.number_to_currency obj.call_field(ac) } },
    nonop_funds: {  label: 'Nonop Funds',
                    decorator: -> (view, obj, ac) { view.number_to_currency obj.call_field(ac) } },
    division__code: { label: 'Division' },
    department__code: { label: 'Department' },
    unit__code: { label: 'Unit' },
    review_status: { label: 'Review Status' }
  }.freeze

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
