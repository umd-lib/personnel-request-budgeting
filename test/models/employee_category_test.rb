require 'test_helper'

# Tests for the "EmployeeCategory" model
class EmployeeCategoryTest < ActiveSupport::TestCase
  def setup
    @emp_category = employee_categories(:one)
  end

  test 'should be valid' do
    assert @emp_category.valid?
  end

  test 'code should be present' do
    @emp_category.code = '  '
    assert_not @emp_category.valid?
  end

  test 'name should be present' do
    @emp_category.name = '  '
    assert_not @emp_category.valid?
  end
end
