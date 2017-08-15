# A Labor and Assistance staffing request
class LaborRequest < Request
  VALID_EMPLOYEE_TYPES = ['Exempt', 'Faculty', 'Graduate Assistant', 'Non-exempt'].freeze
  VALID_REQUEST_TYPES = %w[New Renewal].freeze

  class << self
    def human_name
      'Labor and Assistance Requests'
    end

    # all the fields associated to the model
    def fields
      %i[ position_title employee_type request_type contractor_name
          number_of_positions hourly_rate hours_per_week number_of_weeks annual_cost
          nonop_funds nonop_source justification organization__name
          review_status__name review_comment created_at updated_at ]
    end

    # Returns an ordered array used in the index pages
    def index_fields
      fields - %i[nonop_source justification review_comment created_at updated_at]
    end
  end

  monetize :hourly_rate_cents

  validates :contractor_name, presence: true, if: :contractor_name_required?

  validates :number_of_positions, presence: true, numericality: true
  validates :hours_per_week, presence: true, numericality: true
  validates :number_of_weeks, presence: true, numericality: true

  # Returns the annual cost
  def annual_cost
    (number_of_positions * hourly_rate * hours_per_week * number_of_weeks)
  end

  def contractor_name_required?
    request_type == 'Renewal'
  end

  default_scope(lambda do
    includes(%i[review_status organization]).where(request_model_type: LaborRequest.request_model_types['labor'])
  end)
end
