require 'test_helper'
require 'integration/personnel_requests_test_helper'

# Integration test for the LaborRequest show page
class LaborRequestsShowTest < ActionDispatch::IntegrationTest
  include PersonnelRequestsTestHelper

  def setup
    @labor_request = labor_requests(:fac_hrly_renewal)
  end

  test 'annual cost field should be displayed' do
    get labor_request_path(@labor_request)
    assert_select '[id=annual_cost]', 1
  end

  test 'currency field values show with two decimal places' do
    get labor_request_path(@labor_request)

    currency_fields = %w(hourly_rate annual_cost nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        verify_two_digit_currency_field(field, e.text)
      end
    end
  end

  test 'nonop funds labels should be internationalized' do
    get labor_request_path(@labor_request)
    verify_i18n_label('th', 'activerecord.attributes.labor_request.nonop_funds')
    verify_i18n_label('th', 'activerecord.attributes.labor_request.nonop_source')
  end
end
