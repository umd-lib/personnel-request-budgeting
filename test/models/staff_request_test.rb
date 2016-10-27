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

  test 'position title should be present' do
    @staff_request.position_title = '   '
    assert_not @staff_request.valid?
  end

  test 'request type should be present' do
    @staff_request.request_type_id = nil
    assert_not @staff_request.valid?
  end

  test 'should allow valid request types' do
    # lets do all cept payadj which also requires a employee_name 
    StaffRequest::VALID_REQUEST_TYPE_CODES.each do |code|
      next if code == "PayAdj" 
      @staff_request.request_type_id = RequestType.find_by_code(code).id
      assert @staff_request.valid?, "'#{code}' was not accepted as a valid request type!"
    end
   
    # now lets test payadj
    code = "PayAdj" 
    @staff_request.request_type_id = RequestType.find_by_code(code).id
    @staff_request.employee_name = "David Simon"
    assert @staff_request.valid?, "Problem with payadj #{@staff_request.errors.inspect }"
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

  test 'unit must match department' do
    department = departments(:one)
    valid_unit = units(:one)

    @staff_request.department_id = department.id
    @staff_request.unit_id = valid_unit.id
    assert @staff_request.valid?

    invalid_unit = units(:two)
    @staff_request.unit_id = invalid_unit.id
    assert_not @staff_request.valid?
  end
end
