require 'test_helper'

# Tests for the "LaborRequest" model
# rubocop:disable Metrics/ClassLength
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

  test 'unit must match department' do
    department = departments(:one)
    valid_unit = units(:one)

    @labor_request.department_id = department.id
    @labor_request.unit_id = valid_unit.id
    assert @labor_request.valid?

    invalid_unit = units(:two)
    @labor_request.unit_id = invalid_unit.id
    assert_not @labor_request.valid?
  end

  test 'annual_cost should be (hourly_rate * hours_per_week * number_of_weeks)' do
    expected_value = @labor_request.hourly_rate * @labor_request.hours_per_week * @labor_request.number_of_weeks
    assert_equal expected_value, @labor_request.annual_cost
  end
end
