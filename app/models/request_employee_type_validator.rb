# Validates the employee type on requests
class RequestEmployeeTypeValidator < ActiveModel::Validator
  def initialize(options)
    super
    @valid_employee_category_code = options[:valid_employee_category_code] || nil
  end

  def validate(record)
    allowed_employee_type(record)
  end

  private

    # Validates the employee type
    def allowed_employee_type(record)
      valid_employee_types = EmployeeType.employee_types_with_category(@valid_employee_category_code)
      return if valid_employee_types.include?(record.employee_type)
      record.errors.add(:employee_type, 'provided is not allowed for this request.')
    end
end
