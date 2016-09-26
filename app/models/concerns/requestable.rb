## Generic for all request type objects
module Requestable
  extend ActiveSupport::Concern

  included do
    belongs_to :employee_type
    belongs_to :request_type
    belongs_to :department
    belongs_to :unit
    belongs_to :review_status
    has_one :division, through: :department, autosave: false

    validates :employee_type, presence: true
    validates :position_description, presence: true
    validates :request_type, presence: true
    validates :department_id, presence: true
    validates_with RequestDepartmentValidator

    validates_with RequestEmployeeTypeValidator, valid_employee_category_code: self::VALID_EMPLOYEE_CATEGORY_CODE
    validate :allowed_request_type
  end

  # Validates the request type
  def allowed_request_type
    unless self.class::VALID_REQUEST_TYPE_CODES.include?(request_type.try(:code))
      errors.add(:request_type, 'Not an allowed request type for this request.')
    end
  end

  # Returns an array that can be used to generate index/xslx views
  # to set this up, each key is callable on the object. to chain methods,
  # use a double _ ( e.g. labor_request.request_type.code = request_type__code )
  def self.fields
    {}
  end

  # method to call the fields expressed in .fields
  def call_field(field)
    return nil unless self.class.fields.include?(field)
    field.to_s.split('__').inject(self) { |a, e| a.send(e) unless a.nil? }
  end
end
