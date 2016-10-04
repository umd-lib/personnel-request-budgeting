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
end
