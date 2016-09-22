# A Labor and Assistance staffing request
class LaborRequest < ActiveRecord::Base
  VALID_EMPLOYEE_CATEGORY_CODE = 'L&A'.freeze
  VALID_REQUEST_TYPE_CODES = %w(New Renewal).freeze

  include Requestable

  validates :contractor_name, presence: true, if: :contractor_name_required?
  validates :number_of_positions, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :hourly_rate, presence: true, numericality: { greater_than: 0.00 }
  validates :hours_per_week, presence: true, numericality: { greater_than: 0.00 }
  validates :number_of_weeks, presence: true, numericality: { only_integer: true, greater_than: 0 }

  FIELDS = {
    position_description: { label: 'Position Description' },
    employee_type__code: { label: 'Employee Type' },
    request_type__code: { label: 'Request Type' },
    contractor_name: { label: 'Contractor Name' },
    number_of_positions: { label: 'Number of Positions' },
    hourly_rate: {  label: 'Hourly Rate',
                    decorator: :number_to_currency },
    hours_per_week: { label: 'Hours per Week' },
    number_of_weeks: { label: 'Numbers of Weeks' },
    annual_cost: {  label: 'Annual Cost',
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
      errors.add(:request_type, 'Not an allowed request type for this request.')
    end
  end 
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

  # Returns the annual cost
  def annual_cost
    (hourly_rate * hours_per_week * number_of_weeks)
  end

  # Ransacker used to define "annual_cost" field. Needed for sorting.
  ransacker :annual_cost do |parent|
    (parent.table[:hourly_rate] * parent.table[:hours_per_week] * parent.table[:number_of_weeks])
  end
end
