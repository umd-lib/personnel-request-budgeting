# A Contractor Request
class ContractorRequest < Request
  VALID_EMPLOYEE_TYPES = ['Contractor Type 2', 'ContFac'].freeze
  VALID_REQUEST_TYPES = %w[Renewal New ConvertC1].freeze

  class << self
    def human_name
      'Contractor Requests'
    end

    # all the fields associated to the model
    def fields
      %i[ position_title employee_type request_type
          contractor_name number_of_months annual_base_pay
          nonop_funds nonop_source justification organization__name
          review_status__name review_comment created_at updated_at ]
    end

    # Returns an ordered array used in the index pages
    def index_fields
      fields - %i[nonop_source justification review_comment created_at updated_at]
    end
  end

  monetize :annual_base_pay_cents
  validates :annual_base_pay, presence: true
  validates :number_of_months, presence: true
  validates :contractor_name, presence: true, if: :contractor_name_required?

  def contractor_name_required?
    request_type == 'Renewal'
  end

  default_scope(lambda do
    includes(%i[review_status organization]).where(request_model_type: StaffRequest.request_model_types['contractor'])
  end)
end
