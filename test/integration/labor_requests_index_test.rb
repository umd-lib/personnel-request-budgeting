require 'test_helper'

# Integration test for the LaborRequest index page
class LaborRequestsIndexTest < ActionDispatch::IntegrationTest
  test 'currency field values show with two decimal places' do
    get labor_requests_path

    currency_fields = %w(hourly_rate nonop_funds)
    currency_fields.each do |field|
      assert_select 'td[headers=?]', field do |elements|
        elements.each do |e|
          assert_match(/\d\.\d\d/, e.inner_text,
                       "#{field} should have two decimal places")
        end
      end
    end
  end
end
