require 'test_helper'

# Tests for the "Department" model
class DepartmentTest < ActiveSupport::TestCase
  def setup
    @division = divisions(:one)
    @department = @division.departments.build(name: 'Test Department')
  end

  test 'should be valid' do
    assert @department.valid?
  end

  test 'division should be present' do
    @department.division_id = nil
    assert_not @department.valid?
  end
end
