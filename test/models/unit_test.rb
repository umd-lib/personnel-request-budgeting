require 'test_helper'

# Tests for the "Unit" model
class UnitTest < ActiveSupport::TestCase
  def setup
    @department = departments(:one)
    @unit = @department.units.build(
      code: 'TS', name: 'Test Unit')
  end

  test 'should be valid' do
    assert @unit.valid?
  end

  test 'code should be present' do
    @unit.code = '  '
    assert_not @unit.valid?
  end

  test 'code should be unique' do
    duplicate_unit = @unit.dup
    duplicate_unit.code = @unit.code.downcase
    @unit.save!
    assert_not duplicate_unit.valid?
  end

  test 'name should be present' do
    @unit.name = '  '
    assert_not @unit.valid?
  end

  test 'department should be present' do
    @unit.department_id = nil
    assert_not @unit.valid?
  end

  test 'unit without associated records can be deleted' do
    unit = Unit.create(code: 'Delete', name: 'DeleteMe', department: @unit.department)
    assert_equal true, unit.allow_delete?
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      unit.destroy
    end
  end

  test 'unit with associated records cannot be deleted' do
    staff_request = staff_requests(:fac)
    staff_request.department = @unit.department
    staff_request.unit = @unit
    staff_request.save!
    assert_equal false, @unit.allow_delete?
    assert_raise ActiveRecord::DeleteRestrictionError do
      @unit.destroy
    end
  end
end
