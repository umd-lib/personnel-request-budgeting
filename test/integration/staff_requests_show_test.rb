require 'test_helper'

# Integration test for the StaffRequest show page
class StaffRequestsShowTest < ActionDispatch::IntegrationTest
  def setup
    @staff_request = staff_requests(:fac)
  end

  test 'currency field values show with two decimal places' do
    get staff_request_path(@staff_request)

    currency_fields = %w(annual_base_pay nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]", { text: /\d\.\d\d/ },
                    "#{field} should have two decimal places"
    end
  end
end
