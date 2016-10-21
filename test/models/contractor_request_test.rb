require 'test_helper'

# Tests for the "ContractorRequest" model
class ContractorRequestTest < ActiveSupport::TestCase
  def setup
    @contractor_request = contractor_requests(:c2)
  end

  test 'should be valid' do
    assert @contractor_request.valid?
  end

  test 'employee type should be present' do
    @contractor_request.employee_type_id = nil
    assert_not @contractor_request.valid?
  end

  test 'position title should be present' do
    @contractor_request.position_title = '   '
    assert_not @contractor_request.valid?
  end

  test 'request type should be present' do
    @contractor_request.request_type_id = nil
    assert_not @contractor_request.valid?
  end

  test 'should allow valid request types' do
    ContractorRequest::VALID_REQUEST_TYPE_CODES.each do |code|
      @contractor_request.request_type_id = RequestType.find_by_code(code).id
      assert @contractor_request.valid?, "'#{code}' was not accepted as a valid request type!"
    end
  end

  test 'should not allow invalid request types' do
    invalid_request_types = RequestType.all.to_a.select do |type|
      !ContractorRequest::VALID_REQUEST_TYPE_CODES.include?(type.code)
    end

    invalid_request_types.each do |type|
      @contractor_request.request_type_id = type.id
      assert_not @contractor_request.valid?, "'#{type.code}' was accepted as a valid request type!"
    end
  end

  test 'should require contractor name if request type is Renewal' do
    @contractor_request = contractor_requests(:cont_fac_renewal)
    @contractor_request.contractor_name = ''
    assert_not @contractor_request.valid?
  end

  test 'number of months should be present' do
    @contractor_request.number_of_months = nil
    assert_not @contractor_request.valid?
  end

  test 'number of months should be greater than zero' do
    test_values = [-1, 0, 0.5]
    test_values.each do |t|
      @contractor_request.number_of_months = t
      assert_not @contractor_request.valid?, "#{t} was accepted as valid"
    end
  end

  test 'annual base pay should be present' do
    @contractor_request.annual_base_pay = nil
    assert_not @contractor_request.valid?
  end

  test 'department should be present' do
    @contractor_request.department_id = nil
    assert_not @contractor_request.valid?
  end

  test 'should not allow non-existent department' do
    @contractor_request.department_id = -1
    assert_not @contractor_request.valid?
  end

  test 'unit must match department' do
    department = departments(:one)
    valid_unit = units(:one)

    @contractor_request.department_id = department.id
    @contractor_request.unit_id = valid_unit.id
    assert @contractor_request.valid?

    invalid_unit = units(:two)
    @contractor_request.unit_id = invalid_unit.id
    assert_not @contractor_request.valid?
  end
end
