# Holds common methods for testing the personnel request index pages.
module PersonnelRequestIndexTestHelper

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
        assert_match(/\d\.\d\d$/, display_value, "#{field} should have two decimal places")
      end
    end
  end
end
