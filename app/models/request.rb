# This is the base line model for Request that is used by all other
# request types
class Request < ApplicationRecord
  class << self
    def policy_class
      RequestPolicy
    end

    # returns just the source_class for Archived records
    def source_class
      name.remove(/^Archived/).constantize
    end
  end

  attr_accessor :archived_fiscal_year
  attr_accessor :archived_proxy
  # sometimes in the app we take Archived class and cast it as a regular
  # non-archived record to display in a view.
  def archived_proxy?
    archived_proxy || false
  end

  enum request_model_type: { contractor: 0, labor: 1, staff: 2 }
  enum employee_type: { "Contractor Type 1": 0, "Faculty Hourly": 1, "Student": 3,
                        "Exempt": 4, "Faculty": 5, "Graduate Assistant": 6,
                        "Non-exempt": 7, "Contractor Type 2": 8, "ContFac": 9 }
  enum request_type: { ConvertC1: 0, ConvertCont: 1, New: 2, "Pay Adjustment": 3, "Backfill": 4,
                       "Renewal": 5, 'Pay Adjustment - Other': 6,
                       'Pay Adjustment - Reclass': 7, 'Pay Adjustment - Stipend': 8 }
  belongs_to :review_status, counter_cache: true
  belongs_to :organization, required: true, counter_cache: true
  belongs_to :unit, class_name: 'Organization'

  validates :position_title, presence: true
  validates :employee_type, presence: true
  validates :request_type, presence: true

  validate :org_must_be_dept
  def org_must_be_dept
    return if organization && organization.organization_type == 'department'
    errors.add(:organization, 'Must have a department specified.')
  end

  validates :justification, presence: true
  validate :new_justifications_cant_be_long
  def new_justifications_cant_be_long
    return if review_status && review_status.code !=  'UnderReview'
    return if justification && justification.split(/\s+/).length < 126
    errors.add(:justification, 'Must be 125 words or less')
  end

  alias_attribute :description, :position_title

  monetize :nonop_funds_cents, allow_nil: true

  after_initialize(lambda do
    return if has_attribute?(:review_status_id) && review_status_id
    self.review_status = ReviewStatus.find_by(code: 'UnderReview')
  end)

  # method to call the fields expressed in .fields
  def call_field(field)
    field.to_s.split('__').inject(self) { |a, e| a.send(e) unless a.nil? }
  end

  def cutoff?
    persisted? ? (organization && organization.cutoff?) : false
  end

  def source_class
    self.class.source_class
  end

  # this casts the record as its source type
  def to_source_proxy
    return self unless self.class.name =~ /^Archive/
    attrs = attributes.slice(*source_class.attribute_names).merge(archived_proxy: true,
                                                                  archived_fiscal_year: fiscal_year)
    source_class.new(attrs)
  end
end
