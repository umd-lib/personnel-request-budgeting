require 'test_helper'

# Tests for the "Department" model
class DepartmentTest < ActiveSupport::TestCase
  def setup
    @division = divisions(:one)
    @department = @division.departments.build(
      code: 'TD', name: 'Test Department')
  end

  test 'should be valid' do
    assert @department.valid?
  end

  test 'code should be present' do
    @department.code = '  '
    assert_not @department.valid?
  end

  test 'code should be unique' do
    duplicate_department = @department.dup
    duplicate_department.code = @department.code.upcase
    @department.save!
    assert_not duplicate_department.valid?
  end

  test 'name should be present' do
    @department.name = '  '
    assert_not @department.valid?
  end

  test 'division should be present' do
    @department.division_id = nil
    assert_not @department.valid?
  end

  test 'department without associated records can be deleted' do
    @department = Department.create(code: 'Delete', name: 'DeleteMe')
    assert_equal true, @department.allow_delete?
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      @department.destroy
    end
  end

  test 'department with associated records cannot be deleted' do
    @department = Department.create(code: 'NoDelete', name: 'DoNotDeleteMe', division: @division)
    Subdepartment.create(code: 'Test', name: 'Test subdepartment', department: @department)
    assert_equal false, @department.allow_delete?
    assert_raise ActiveRecord::DeleteRestrictionError do
      @department.destroy
    end
  end
end
