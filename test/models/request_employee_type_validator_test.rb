require 'test_helper'

# Tests for the "RequestEmployeeTypeValidator" validator
class RequestEmployeeTypeValidatorTest < ActiveSupport::TestCase
  def setup
    @record = MockRequest.new
    @record.employee_type = employee_types(:one)
    @record.employee_type_id = @record.employee_type.id
  end

  test 'employee type should be present' do
    @record.employee_type_id = nil
    assert_not @record.valid?
  end

  test 'should allow valid employee types' do
    validator = MockRequest.validators.first
    valid_employee_category_code = validator.options[:valid_employee_category_code]
    valid_emp_types(valid_employee_category_code).each do |type|
      @record.employee_type = type
      @record.employee_type_id = type.id
      assert @record.valid?, "'#{type.code}' was not accepted as a valid employee type!"
    end
  end

  test 'should not allow invalid employee types' do
    validator = MockRequest.validators.first
    valid_employee_category_code = validator.options[:valid_employee_category_code]
    invalid_emp_types(valid_employee_category_code).each do |type|
      @record.employee_type_id = type.id
      assert_not @record.valid?, "'#{type.code}' was accepted as a valid employee type!"
    end
  end

  private

    # Returns an Array of valid EmployeeType codes
    def valid_emp_types(category_code)
      EmployeeType.employee_types_with_category(category_code)
    end

    # Returns an Array of invalid EmployeeTypes
    def invalid_emp_types(category_code)
      EmployeeType.all.to_a - valid_emp_types(category_code)
    end

    # Mock object used for constructing object to validate
    class MockRequest
      include ActiveModel::Validations
      attr_accessor :employee_type_id, :employee_type

      validates_with RequestEmployeeTypeValidator, valid_employee_category_code: 'L&A'
    end
end
