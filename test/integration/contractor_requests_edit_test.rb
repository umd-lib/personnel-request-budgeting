require 'test_helper'

# Integration test for the ContractorRequest edit page
class ContractorRequestsEditTest < ActionDispatch::IntegrationTest
  def setup
    @contractor_request = contractor_requests(:cont_fac_renewal)
  end

  test 'currency field values show with two decimal places' do
    get edit_contractor_request_path(@contractor_request)

    currency_fields = %w(contractor_request_annual_base_pay contractor_request_nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        assert_match(/\d\.\d\d/, e.attribute('value'),
                     "#{field} should have two decimal places")
      end
    end
  end
end
