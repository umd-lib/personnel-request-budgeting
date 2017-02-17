# A Labor and Assistance staffing request
class LaborRequest < ActiveRecord::Base
  VALID_EMPLOYEE_CATEGORY_CODE = 'L&A'.freeze
  VALID_REQUEST_TYPE_CODES = %w(New Renewal).freeze

  include Requestable

  belongs_to :department, counter_cache: true
  belongs_to :unit, counter_cache: true
  belongs_to :employee_type, counter_cache: true
  belongs_to :request_type, counter_cache: true
  belongs_to :review_status, counter_cache: true

  validates :contractor_name, presence: true, if: :contractor_name_required?
  validates :number_of_positions, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validates :hours_per_week, presence: true, numericality: { greater_than: 0.00 }
  validates :number_of_weeks, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :justification, presence: true

  monetize :hourly_rate_cents, allow_nil: false, numericality: { greater_than: 0 }

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

  # Returns the annual cost
  def annual_cost
    (number_of_positions * hourly_rate * hours_per_week * number_of_weeks)
  end

  # Ransacker used to define "annual_cost" field. Needed for sorting.
  ransacker :annual_cost do |parent|
    parent.table[:number_of_positions] *
      parent.table[:hourly_rate] *
      parent.table[:hours_per_week] *
      parent.table[:number_of_weeks]
  end
end
