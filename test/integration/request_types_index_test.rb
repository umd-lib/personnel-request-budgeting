require 'test_helper'

# Integration test for the RequestTypes index page
class RequestTypesIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w(code name)

    get request_types_path
    assert_template 'request_types/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get request_types_path, q: q_param
        assert_template 'request_types/index'

        RequestType.ransack(q_param).result.each do |entry|
          assert_select 'a[href=?]', request_type_path(entry)
        end
      end
    end
  end
end
