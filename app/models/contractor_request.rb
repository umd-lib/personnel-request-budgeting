# A Salaried Contractor staffing request
class ContractorRequest < ActiveRecord::Base
  VALID_EMPLOYEE_CATEGORY_CODE = 'SC'.freeze
  VALID_REQUEST_TYPE_CODES = %w(ConvertC1 New Renewal).freeze

  include Requestable

  validates :contractor_name, presence: true, if: :contractor_name_required?
  validates :number_of_months, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :annual_base_pay, presence: true
  validates_with RequestDepartmentValidator

  FIELDS = {
    position_description: { label: 'Position Description' },
    employee_type__code: { label: 'Employee Type' },
    request_type__code: { label: 'Request Type' },
    contractor_name: { label: 'Contractor Name' },
    number_of_months: { label: 'Number of Months' },
    annual_base_pay: {  label: 'Annual Base Pay',
                        decorator: :number_to_currency },
    nonop_funds: { label: 'Nonop Funds',
                   decorator: :number_to_currency },
    division__code: { label: 'Division' },
    department__code: { label: 'Department' },
    unit__code: { label: 'Unit' },
    review_status: { label: 'Review Status' }
  }.freeze

  # Returns an array that can be used to generate index/xslx views
  # to set this up, each key is callable on the object. to chain methods,
  # use a double _ ( e.g. labor_request.request_type.code = request_type__code )
  def self.fields
    FIELDS
  end

  # Returns true if the contractor name is required.
  def contractor_name_required?
    request_type.try(:code) == 'Renewal'
  end
end
