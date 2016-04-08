require 'test_helper'

# Tests for the "EmployeeType" model
class EmployeeTypeTest < ActiveSupport::TestCase
  def setup
    @emp_category = employee_categories(:one)
    @emp_type = @emp_category.employee_types.build(code: 'TT', name: 'Test Type')
  end

  test 'should be valid' do
    assert @emp_type.valid?
  end

  test 'code should be present' do
    @emp_type.code = '  '
    assert_not @emp_type.valid?
  end

  test 'code should be unique' do
    duplicate_emp_type = @emp_type.dup
    duplicate_emp_type.code = @emp_type.code.upcase
    @emp_type.save!
    assert_not duplicate_emp_type.valid?
  end

  test 'name should be present' do
    @emp_type.name = '  '
    assert_not @emp_type.valid?
  end

  test 'employee category should be present' do
    @emp_type.employee_category = nil
    assert_not @emp_type.valid?
  end

  test 'employee_types_with_category should return empty array when given nil' do
    assert EmployeeType.employee_types_with_category(nil).empty?
  end

  test 'employee_types_with_category should return correct types for category' do
    category_code = employee_categories(:l_and_a).code
    employee_types = EmployeeType.employee_types_with_category(category_code)
    employee_types.each do |emp_type|
      assert_equal category_code, emp_type.employee_category.code,
                   "'#{emp_type.name}' is not of employee category '#{category_code}'"
    end
  end
end
