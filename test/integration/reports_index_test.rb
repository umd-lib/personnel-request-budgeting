require 'test_helper'

# Integration test for the Reports index page
class ReportsIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    # Ransack doesn't understand aliases for sorting, so using
    # "user_name" instead of "creator_name"
    sort_columns = %w(name format user_name created_at status)
    enum_fields = %w(format status)

    get reports_path
    assert_template 'reports/index'

    # Verify sort links
    assert_select 'a.sort_link', count: sort_columns.size

    # Verify sorting
    sort_columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get reports_path, q: q_param
        assert_template 'reports/index'

        verify_table_sorting(response, column, order, enum_fields)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize

  # Verifies the sorting of a particular column in a table by comparing the
  # order of the displayed strings.
  #
  # This method assumes that each row of the table contains a "td" element
  # with a "headers" attribute corresponding to the field, i.e.:
  #
  # <td headers="name">...</td>
  #
  # @param response the page response
  # @param column the column attribute being sorted
  # @param order 'asc' if the order is ascending, 'desc', if descending
  # @param enum_fields an Array of fields held as a numeric enumeration in the
  #   model
  # @return [void]
  def verify_table_sorting(response, column, order, enum_fields)
    doc = Nokogiri::HTML(response.body)

    # Get the text for the column from each record, using "header" to
    # identify the field value.
    records_text = doc.xpath("//td[@headers='#{column}']").map(&:child).map(&:text)

    # Postgres and Ruby collate spaces differently, so convert spaces to
    # underscores
    records_text.each { |r| r.tr!(' ', '_') }

    # Enum fields should be converted to their numeric representation
    if enum_fields.include?(column)
      records_text.map! { |r| Report.send(column.pluralize)[r] }
    end

    expected_text = order == 'asc' ? records_text.sort : records_text.sort.reverse

    assert_equal expected_text, records_text,
                 "Improper sorting column '#{column}', order '#{order}'"
  end

  # rubocop:enable Metrics/AbcSize

  test 'there should be a delete button but not an edit button' do
    get reports_path

    Report.ransack.result.each do |entry|
      assert_select 'tr[id=?]', "report_#{entry.id}"
      assert_select 'a[class~="delete"]'
      assert_select 'a[title~="Edit"]', false, 'There should not be an edit button'
    end
  end

  test 'there should  be a d/l button for status=completed and no d/l for all others' do
    report_with_error = reports(:report_with_error)
    report_completed = reports(:report_completed)
    get reports_path
    assert_select 'tr[id=?]', "report_#{report_with_error.id}" do
      assert_select 'a[class~="download"]', false
    end

    assert_select 'tr[id=?]', "report_#{report_completed.id}" do
      assert_select 'a[class~="download"]'
    end
  end
end
