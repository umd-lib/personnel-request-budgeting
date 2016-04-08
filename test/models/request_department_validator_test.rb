require 'test_helper'

# Tests for the "RequestDepartmentValidator" validator
class RequestDepartmentValidatorTest < ActiveSupport::TestCase
  def setup
    @record = MockRequest.new
    @record.department_id = departments(:one).id
    @record.subdepartment_id = subdepartments(:one).id
  end

  test 'department should be present' do
    @record.department_id = nil
    assert_not @record.valid?
  end

  test 'should not allow non-existent department' do
    @record.department_id = -1
    assert_not @record.valid?
  end

  test 'subdepartment must match department' do
    department = departments(:one)
    valid_subdepartment = subdepartments(:one)

    @record.department_id = department.id
    @record.subdepartment_id = valid_subdepartment.id
    assert @record.valid?, @record.errors.to_a.join.to_s

    invalid_subdepartment = subdepartments(:two)
    @record.subdepartment_id = invalid_subdepartment.id
    assert_not @record.valid?
  end

  # Mock object used for constructing object to validate
  class MockRequest
    include ActiveModel::Validations
    attr_accessor :department_id
    attr_accessor :subdepartment_id

    validates_with RequestDepartmentValidator
  end
end
