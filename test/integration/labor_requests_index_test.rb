require 'test_helper'

# Integration test for the LaborRequest index page
class LaborRequestsIndexTest < ActionDispatch::IntegrationTest
  test 'currency field values show with two decimal places' do
    get labor_requests_path

    currency_fields = %w(hourly_rate nonop_funds)
    currency_fields.each do |field|
      assert_select "td[headers=#{field}]", { text: /\d\.\d\d/ },
                    "#{field} should have two decimal places"
    end
  end
end
