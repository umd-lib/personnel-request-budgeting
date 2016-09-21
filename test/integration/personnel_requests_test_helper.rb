require 'test_helper'

# Holds common methods for testing the personnel request pages.
module PersonnelRequestsTestHelper
  # Verifies that the given currency fields only display two digits after the
  # decimal point.
  #
  # doc: The NokoGiri::HTML document generated from the response
  # currency_fields: An array of currency fields in the table
  # optional_fields: Array of fields in currency_fields that are allowed to be
  #                  blank
  def verify_two_digit_currency_fields(doc, currency_fields, optional_fields)
    currency_fields.each do |field|
      table_entries = doc.xpath("//td[@headers='#{field}']")
      table_entries.each do |entry|
        display_value = entry.text
        next if display_value.empty? && optional_fields.include?(field)
        verify_two_digit_currency_field(field, display_value)
      end
    end
  end

  # Verifies the options in a drop-down with the given id from the given
  # response by comparing them to the expected options text.
  #
  # response - a response to a page request
  # select_id - the "id" of an HTML "select" element
  # expected_options_text - the text that should be displayed in the options.
  def verify_options(response, select_id, expected_options_text)
    doc = Nokogiri::HTML(response.body)
    options = doc.xpath("//select[@id='#{select_id}']/option")
    options_text = options.map(&:text)
    assert_equal expected_options_text.sort, options_text.sort
  end
end
