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

  test 'name should be present' do
    @subdepartment.name = '  '
    assert_not @subdepartment.valid?
  end

  test 'department should be present' do
    @subdepartment.department_id = nil
    assert_not @subdepartment.valid?
  end
end
