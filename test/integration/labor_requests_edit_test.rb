require 'test_helper'

# Integration test for the LaborRequest edit page
class LaborRequestsEditTest < ActionDispatch::IntegrationTest
  def setup
    @labor_request = labor_requests(:fac_hrly_renewal)
  end

  test 'currency field values show with two decimal places' do
    get edit_labor_request_path(@labor_request)

    currency_fields = %w(labor_request_hourly_rate labor_request_nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        assert_match(/\d\.\d\d/, e.attribute('value'),
                     "#{field} should have two decimal places")
      end
    end
  end
end
