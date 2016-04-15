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

  test 'index including pagination' do
    get labor_requests_path

    assert_template 'labor_requests/index'
    assert_select 'div.pagination'
    LaborRequest.paginate(page: 1).each do |request|
      assert_select 'a[href=?]', labor_request_path(request)
    end
  end
end
