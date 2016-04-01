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

  test 'name should be present' do
    @department.name = '  '
    assert_not @department.valid?
  end

  test 'division should be present' do
    @department.division_id = nil
    assert_not @department.valid?
  end
end
