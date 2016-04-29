require 'test_helper'

# Tests for the "Subdepartment" model
class SubdepartmentTest < ActiveSupport::TestCase
  def setup
    @department = departments(:one)
    @subdepartment = @department.subdepartments.build(
      code: 'TS', name: 'Test Subdepartment')
  end

  test 'should be valid' do
    assert @subdepartment.valid?
  end

  test 'code should be present' do
    @subdepartment.code = '  '
    assert_not @subdepartment.valid?
  end

  test 'code should be unique' do
    duplicate_subdepartment = @subdepartment.dup
    duplicate_subdepartment.code = @subdepartment.code.upcase
    @subdepartment.save!
    assert_not duplicate_subdepartment.valid?
  end

  test 'name should be present' do
    @subdepartment.name = '  '
    assert_not @subdepartment.valid?
  end

  test 'department should be present' do
    @subdepartment.department_id = nil
    assert_not @subdepartment.valid?
  end

  test 'subdepartment without associated records can be deleted' do
    subdepartment = Subdepartment.create(code: 'Delete', name: 'DeleteMe', department: @subdepartment.department)
    assert_equal true, subdepartment.allow_delete?
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      subdepartment.destroy
    end
  end

  test 'subdepartment with associated records cannot be deleted' do
    staff_request = staff_requests(:fac)
    staff_request.department = @subdepartment.department
    staff_request.subdepartment = @subdepartment
    staff_request.save!
    assert_equal false, @subdepartment.allow_delete?
    assert_raise ActiveRecord::DeleteRestrictionError do
      @subdepartment.destroy
    end
  end
end
