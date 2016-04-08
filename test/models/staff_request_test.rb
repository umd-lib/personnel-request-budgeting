require 'test_helper'

# Tests for the "StaffRequest" model
class StaffRequestTest < ActiveSupport::TestCase
  def setup
    @staff_request = staff_requests(:fac)
  end

  test 'should be valid' do
    assert @staff_request.valid?
  end

  test 'employee type should be present' do
    @staff_request.employee_type_id = nil
    assert_not @staff_request.valid?
  end

  test 'position description should be present' do
    @staff_request.position_description = '   '
    assert_not @staff_request.valid?
  end

  test 'request type should be present' do
    @staff_request.request_type_id = nil
    assert_not @staff_request.valid?
  end

  test 'should allow valid request types' do
    StaffRequest::VALID_REQUEST_TYPE_CODES.each do |code|
      @staff_request.request_type_id = RequestType.find_by_code(code).id
      assert @staff_request.valid?, "'#{code}' was not accepted as a valid request type!"
    end
  end

  test 'should not allow invalid request types' do
    invalid_request_types = RequestType.all.to_a.select do |type|
      !StaffRequest::VALID_REQUEST_TYPE_CODES.include?(type.code)
    end

    invalid_request_types.each do |type|
      @staff_request.request_type_id = type.id
      assert_not @staff_request.valid?, "'#{type.code}' was accepted as a valid request type!"
    end
  end

  test 'annual base pay should be present' do
    @staff_request.annual_base_pay = nil
    assert_not @staff_request.valid?
  end

  test 'department should be present' do
    @staff_request.department_id = nil
    assert_not @staff_request.valid?
  end

  test 'should not allow non-existent department' do
    @staff_request.department_id = -1
    assert_not @staff_request.valid?
  end

  test 'subdepartment must match department' do
    department = departments(:one)
    valid_subdepartment = subdepartments(:one)

    @staff_request.department_id = department.id
    @staff_request.subdepartment_id = valid_subdepartment.id
    assert @staff_request.valid?

    invalid_subdepartment = subdepartments(:two)
    @staff_request.subdepartment_id = invalid_subdepartment.id
    assert_not @staff_request.valid?
  end
end
