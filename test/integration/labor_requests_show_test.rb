require 'test_helper'

class LaborRequestsShowTest < ActionDispatch::IntegrationTest
  def setup
    @labor_request = labor_requests(:fac_hrly_renewal)
  end

  test 'currency field values show with two decimal places' do
    get labor_request_path(@labor_request)

    currency_fields = %w(hourly_rate nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]", { text: /\d\.\d\d/ },
                    "#{field} should have two decimal places"
    end
  end
end
