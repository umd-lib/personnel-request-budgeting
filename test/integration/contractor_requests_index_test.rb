require 'test_helper'

# Integration test for the ContractorRequest index page
class ContractorRequestsIndexTest < ActionDispatch::IntegrationTest
  test 'currency field values show with two decimal places' do
    get contractor_requests_path

    currency_fields = %w(annual_base_pay nonop_funds)
    currency_fields.each do |field|
      assert_select "td[headers=#{field}]", { text: /\d\.\d\d/ },
                    "#{field} should have two decimal places"
    end
  end
end
