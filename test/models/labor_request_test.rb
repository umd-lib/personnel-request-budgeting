require 'test_helper'

# Tests for the "LaborRequest" model
class LaborRequestTest < ActiveSupport::TestCase
  def setup
    @labor_request = labor_requests(:c1)
  end

  test 'should be valid' do
    assert @labor_request.valid?
  end

  test 'employee type should be present' do
    @labor_request.employee_type_id = nil
    assert_not @labor_request.valid?
  end

  test 'should allow valid employee types' do
    valid_emp_types.each do |type|
      @labor_request.employee_type_id = type.id
      assert @labor_request.valid?, "'#{type.code}' was not accepted as a valid employee type!"
    end
  end

  test 'should not allow invalid employee types' do
    invalid_emp_types.each do |type|
      @labor_request.employee_type_id = type.id
      assert_not @labor_request.valid?, "'#{type.code}' was accepted as a valid employee type!"
    end
  end

  test 'position description should be present' do
    @labor_request.position_description = '   '
    assert_not @labor_request.valid?
  end

  test 'request type should be present' do
    @labor_request.request_type_id = nil
    assert_not @labor_request.valid?
  end

  test 'should allow valid request types' do
    LaborRequest::VALID_REQUEST_TYPE_CODES.each do |code|
      @labor_request.request_type_id = RequestType.find_by_code(code).id
      assert @labor_request.valid?, "'#{code}' was not accepted as a valid request type!"
    end
  end

  test 'should not allow invalid request types' do
    invalid_request_types = RequestType.all.to_a.select do |type|
      !LaborRequest::VALID_REQUEST_TYPE_CODES.include?(type.code)
    end

    invalid_request_types.each do |type|
      @labor_request.request_type_id = type.id
      assert_not @labor_request.valid?, "'#{type.code}' was accepted as a valid request type!"
    end
  end

  test 'should require contractor name if request type is Renewal' do
    @labor_request = labor_requests(:fac_hrly_renewal)
    @labor_request.contractor_name = ''
    assert_not @labor_request.valid?
  end

  test 'number of positions should be present' do
    @labor_request.number_of_positions = nil
    assert_not @labor_request.valid?
  end

  test 'number of positions should be greater than zero' do
    test_values = [-1, 0, 0.5]
    test_values.each do |t|
      @labor_request.number_of_positions = t
      assert_not @labor_request.valid?, "#{t} was accepted as valid"
    end
  end

  test 'hourly rate should be present' do
    @labor_request.hourly_rate = nil
    assert_not @labor_request.valid?
  end

  test 'hourly rate should be greater than zero' do
    test_values = [-1.00, 0.00]
    test_values.each do |t|
      @labor_request.hourly_rate = t
      assert_not @labor_request.valid?, "#{t} was accepted as valid"
    end
  end

  test 'hours per week should be present' do
    @labor_request.hours_per_week = nil
    assert_not @labor_request.valid?
  end

  test 'hours per week should be greater than zero' do
    test_values = [-1.00, 0.00]
    test_values.each do |t|
      @labor_request.hours_per_week = t
      assert_not @labor_request.valid?, "#{t} was accepted as valid"
    end
  end

  test 'number of weeks should be present' do
    @labor_request.number_of_weeks = nil
    assert_not @labor_request.valid?
  end

  test 'number of weeks should be greater than zero' do
    test_values = [-1, 0, 0.5]
    test_values.each do |t|
      @labor_request.number_of_weeks = t
      assert_not @labor_request.valid?, "#{t} was accepted as valid"
    end
  end

  test 'department should be present' do
    @labor_request.department_id = nil
    assert_not @labor_request.valid?
  end

  test 'should not allow non-existent department' do
    @labor_request.department_id = -1
    assert_not @labor_request.valid?
  end

  test 'subdepartment must match department' do
    department = departments(:one)
    valid_subdepartment = subdepartments(:one)

    @labor_request.department_id = department.id
    @labor_request.subdepartment_id = valid_subdepartment.id
    assert @labor_request.valid?

    invalid_subdepartment = subdepartments(:two)
    @labor_request.subdepartment_id = invalid_subdepartment.id
    assert_not @labor_request.valid?
  end

  private

    # Returns an Array of all EmployeeTypes
    def all_emp_types
      EmployeeType.all.to_a
    end

    # Returns an Array of valid EmployeeType codes
    def valid_emp_types
      all_emp_types.select do |type|
        type.employee_category.code == LaborRequest::VALID_EMPLOYEE_CATEGORY_CODE
      end
    end

    # Returns an Array of invalid EmployeeTypes
    def invalid_emp_types
      all_emp_types - valid_emp_types
    end
end
