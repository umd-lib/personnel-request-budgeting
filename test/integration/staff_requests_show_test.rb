require 'test_helper'
require 'integration/personnel_requests_test_helper'

# Integration test for the StaffRequest show page
class StaffRequestsShowTest < ActionDispatch::IntegrationTest
  include PersonnelRequestsTestHelper

  def setup
    @staff_request = staff_requests(:fac)
  end

  test 'currency field values show with two decimal places' do
    get staff_request_path(@staff_request)

    currency_fields = %w(annual_base_pay nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        verify_two_digit_currency_field(field, e.text)
      end
    end
  end

  test 'nonop funds labels should be internationalized' do
    get staff_request_path(@staff_request)
    verify_i18n_label('th', 'activerecord.attributes.staff_request.nonop_funds')
    verify_i18n_label('th', 'activerecord.attributes.staff_request.nonop_source')
  end
end
