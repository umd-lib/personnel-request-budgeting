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

  after_initialize :init

  def init
    self.number_of_positions ||= 1 if has_attribute?(:number_of_positions)
    self.number_of_weeks ||= 1 if has_attribute?(:number_of_weeks)
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

  # Returns the annual cost
  def annual_cost
    (hourly_rate * hours_per_week * number_of_weeks)
  end

  # Ransacker used to define "annual_cost" field. Needed for sorting.
  ransacker :annual_cost do |parent|
    (parent.table[:hourly_rate] * parent.table[:hours_per_week] * parent.table[:number_of_weeks])
  end
end
