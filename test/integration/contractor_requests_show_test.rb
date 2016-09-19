require 'test_helper'

# Integration test for the ContractorRequest show page
class ContractorRequestsShowTest < ActionDispatch::IntegrationTest
  def setup
    @contractor_request = contractor_requests(:cont_fac_renewal)
  end

  test 'currency field values show with two decimal places' do
    get contractor_request_path(@contractor_request)

    currency_fields = %w(annual_base_pay nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        verify_two_digit_currency_field(field, e.text)
      end
    end
  end
end
