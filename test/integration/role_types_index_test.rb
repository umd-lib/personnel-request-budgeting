require 'test_helper'

# Integration test for the RoleTypes index page
class RoleTypesIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w(code name)

    get role_types_path
    assert_template 'role_types/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get role_types_path, q: q_param
        assert_template 'role_types/index'

        # Verify sorting by getting the text of the page, then checking the
        # position of each entry -- the position should increase on each pass.
        page = response.body

        last_result_index = 0
        RoleType.ransack(q_param).result.each do |entry|
          entry_path = role_type_path(entry)
          entry_index = page.index(entry_path)
          assert last_result_index < entry_index, "Failed for '#{q_param[:s]}'"
          assert_select 'tr td a[href=?]', entry_path
          last_result_index = entry_index
        end
      end
    end
  end

  test 'delete action enable status should reflect allow_delete? flag' do
    get role_types_path

    RoleType.ransack.result.each do |entry|
      assert_select 'tr[id=?]', "role_type_#{entry.id}"
      if entry.allow_delete?
        assert_select 'a[class~="delete"]'
      else
        assert_select 'button[class~="delete"]'
      end
    end
  end
end
