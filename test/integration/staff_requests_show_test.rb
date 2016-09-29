require 'test_helper'

# Integration test for the StaffRequest show page
class StaffRequestsShowTest < ActionDispatch::IntegrationTest
  def setup
    @staff_request = staff_requests(:fac)
  end

  test 'currency field values show with two decimal places' do
    get staff_request_path(@staff_request)

    currency_fields = %w(annual_base_pay nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        verify_two_digit_currency_field(field, e.text)
      end
    end
  end

  test 'nonop funds labels should be internationalized' do
    get staff_request_path(@staff_request)
    nonop_funds_i18n_key = 'activerecord.attributes.staff_request.nonop_funds'
    nonop_source_i18n_key = 'activerecord.attributes.staff_request.nonop_source'

    assert I18n.exists?(nonop_funds_i18n_key, :en)
    assert I18n.exists?(nonop_source_i18n_key, :en)

    assert_select 'th', { count: 1, text: I18n.t(nonop_funds_i18n_key) },
                  "No label matching '#{I18n.t(nonop_funds_i18n_key)}' was found."
    assert_select 'th', { count: 1, text: I18n.t(nonop_source_i18n_key) },
                  "No label matching '#{I18n.t(nonop_source_i18n_key)}' was found."
  end
end
