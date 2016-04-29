require 'test_helper'

# Tests for the "RequestDepartmentValidator" validator
class RequestDepartmentValidatorTest < ActiveSupport::TestCase
  def setup
    @record = MockRequest.new
    @record.department_id = departments(:one).id
    @record.unit_id = units(:one).id
  end

  test 'department should be present' do
    @record.department_id = nil
    assert_not @record.valid?
  end

  test 'should not allow non-existent department' do
    @record.department_id = -1
    assert_not @record.valid?
  end

  test 'unit must match department' do
    department = departments(:one)
    valid_unit = units(:one)

    @record.department_id = department.id
    @record.unit_id = valid_unit.id
    assert @record.valid?, @record.errors.to_a.join.to_s

    invalid_unit = units(:two)
    @record.unit_id = invalid_unit.id
    assert_not @record.valid?
  end

  # Mock object used for constructing object to validate
  class MockRequest
    include ActiveModel::Validations
    attr_accessor :department_id
    attr_accessor :unit_id

    validates_with RequestDepartmentValidator
  end
end
