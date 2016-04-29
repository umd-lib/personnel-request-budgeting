require 'test_helper'

# Integration test for the Division index page
class DivisionsIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w(code name)

    get divisions_path
    assert_template 'divisions/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get divisions_path, q: q_param
        assert_template 'divisions/index'

        Division.ransack(q_param).result.each do |entry|
          assert_select 'a[href=?]', division_path(entry)
        end
      end
    end
  end
end
