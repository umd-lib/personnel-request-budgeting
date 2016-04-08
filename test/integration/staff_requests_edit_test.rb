require 'test_helper'

# Integration test for the StaffRequest edit page
class StaffRequestsEditTest < ActionDispatch::IntegrationTest
  def setup
    @staff_request = staff_requests(:fac)
  end

  test 'currency field values show with two decimal places' do
    get edit_staff_request_path(@staff_request)

    currency_fields = %w(staff_request_annual_base_pay staff_request_nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        assert_match(/\d\.\d\d/, e.attribute('value'),
                     "#{field} should have two decimal places")
      end
    end
  end
end
