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

  test 'name should be present' do
    @emp_type.name = '  '
    assert_not @emp_type.valid?
  end

  test 'employee category should be present' do
    @emp_type.employee_category = nil
    assert_not @emp_type.valid?
  end
end
