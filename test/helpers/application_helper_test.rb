require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test 'verify help-text-icon content when provided a valid translation key' do
    existing_translation_key = 'help_text.position_description'
    expected_help_test = raw t('help_text.position_description')

    html_output = help_text_icon(existing_translation_key)
    assert html_output.include?(expected_help_test)
    assert html_output.include?('class="help-text-icon"')
  end

  test 'verify help-text-icon content when provided an invalid translation key' do
    invalid_translation_key = 'this.key.should.not.exist'

    html_output = help_text_icon(invalid_translation_key)
    assert html_output.nil?
  end

  test 'verify confirm_delete_text content when given objects of different types' do
    default_response = t('confirm_delete_prompt.default')
    assert_equal default_response, confirm_delete_text(nil)

    # Key = object to test, Value = expected description
    test_cases = { contractor_requests(:c2) => contractor_requests(:c2).position_description,
                   departments(:one) => departments(:one).name,
                   divisions(:one) => divisions(:one).name,
                   employee_categories(:one) => employee_categories(:one).name,
                   employee_types(:one) => employee_types(:one).name,
                   labor_requests(:c1) => labor_requests(:c1).position_description,
                   reports(:report_completed) => reports(:report_completed).name,
                   request_types(:one) => request_types(:one).name,
                   review_statuses(:approved) => review_statuses(:approved).name,
                   role_cutoffs(:one) => role_cutoffs(:one).description,
                   role_types(:one) => role_types(:one).name,
                   roles(:one) => roles(:one).description,
                   staff_requests(:fac) => staff_requests(:fac).position_description,
                   units(:one) => units(:one).name,
                   users(:test_user) => users(:test_user).name
                 }

    test_cases.each do |test_object, expected_description|
      description = confirm_delete_text(test_object)
      assert description.include?(expected_description),
             "Object '#{test_object}', returned '#{description}', which did not include '#{expected_description}'"
    end
  end
end
