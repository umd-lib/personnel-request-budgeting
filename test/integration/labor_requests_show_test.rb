require 'test_helper'

# Integration test for the LaborRequest show page
class LaborRequestsShowTest < ActionDispatch::IntegrationTest
  def setup
    @labor_request = labor_requests(:fac_hrly_renewal)
  end

  test 'annual cost field should be displayed' do
    get labor_request_path(@labor_request)
    assert_select '[id=annual_cost]', 1
  end

  test 'currency field values show with two decimal places' do
    get labor_request_path(@labor_request)

    currency_fields = %w(hourly_rate annual_cost nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        verify_two_digit_currency_field(field, e.text)
      end
    end
  end

  test 'nonop funds labels should be internationalized' do
    get labor_request_path(@labor_request)
    nonop_funds_i18n_key = 'activerecord.attributes.labor_request.nonop_funds'
    nonop_source_i18n_key = 'activerecord.attributes.labor_request.nonop_source'

    assert I18n.exists?(nonop_funds_i18n_key, :en)
    assert I18n.exists?(nonop_source_i18n_key, :en)

    assert_select 'th', { count: 1, text: I18n.t(nonop_funds_i18n_key) },
                  "No label matching '#{I18n.t(nonop_funds_i18n_key)}' was found."
    assert_select 'th', { count: 1, text: I18n.t(nonop_source_i18n_key) },
                  "No label matching '#{I18n.t(nonop_source_i18n_key)}' was found."
  end
end
