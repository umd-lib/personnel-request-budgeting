require 'test_helper'

# Integration test for the Departments index page
class DepartmentsIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w(code name division_code)

    get departments_path
    assert_template 'departments/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get departments_path, q: q_param
        assert_template 'departments/index'

        Department.ransack(q_param).result.each do |entry|
          assert_select 'a[href=?]', department_path(entry)
        end
      end
    end
  end

  test 'delete action enable status should reflect allow_delete? flag' do
    get departments_path

    Department.ransack.result.each do |entry|
      assert_select 'tr[id=?]', "department_#{entry.id}"
      if entry.allow_delete?
        assert_select 'a[class~="delete"]'
      else
        assert_select 'button[class~="delete"]'
      end
    end
  end
end
