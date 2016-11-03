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

  test 'code should be unique' do
    duplicate_emp_category = @emp_category.dup
    duplicate_emp_category.code = @emp_category.code.upcase
    @emp_category.save!
    assert_not duplicate_emp_category.valid?
  end

  test 'name should be present' do
    @emp_category.name = '  '
    assert_not @emp_category.valid?
  end

  test 'employee category without associated records can be deleted' do
    emp_category = EmployeeCategory.create(code: 'Delete', name: 'DeleteMe')

    assert_equal true, emp_category.allow_delete?
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      emp_category.destroy
    end
  end

  test 'employee category with associated records cannot be deleted' do
    emp_category = EmployeeCategory.create(code: 'NoDelete', name: 'DoNotDeleteMe')
    EmployeeType.create(code: 'Test', name: 'Test Employee Type', employee_category: emp_category)

    assert_equal false, emp_category.allow_delete?
    assert_raise ActiveRecord::DeleteRestrictionError do
      emp_category.destroy
    end
  end
end
