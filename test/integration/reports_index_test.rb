require 'test_helper'

# Integration test for the Reports index page
class ReportsIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w( name format creator created_at status)

    get reports_path
    assert_template 'reports/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get reports_path, q: q_param
        assert_template 'reports/index'

        Report.ransack(q_param).result.each do |entry|
          assert_select 'a[href=?]', report_path(entry)
        end
      end
    end
  end

  test 'there should be a delete button but not an edit button' do
    get reports_path

    Report.ransack.result.each do |entry|
      assert_select 'tr[id=?]', "report_#{entry.id}"
      assert_select 'a[class~="delete"]'
      assert_select 'a[title~="Edit"]', false, 'There should not be an edit button'
    end
  end

  test 'there should  be a d/l button for status=completed and no d/l for all others' do
    stuck = reports(:stuck)
    awesome = reports(:awesome)
    get reports_path
    assert_select 'tr[id=?]', "report_#{stuck.id}" do
      assert_select 'a[class~="download"]', false
    end

    assert_select 'tr[id=?]', "report_#{awesome.id}" do
      assert_select 'a[class~="download"]'
    end
  end
end
