require 'test_helper'

# Integration test for the EmployeeCategories index page
class EmployeeCategoriesIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w(code name)

    get employee_categories_path
    assert_template 'employee_categories/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get employee_categories_path, q: q_param
        assert_template 'employee_categories/index'

        EmployeeCategory.ransack(q_param).result.each do |entry|
          assert_select 'a[href=?]', employee_category_path(entry)
        end
      end
    end
  end

  test 'delete action enable status should reflect allow_delete? flag' do
    get employee_categories_path

    EmployeeCategory.ransack.result.each do |entry|
      assert_select 'tr[id=?]', "employee_category_#{entry.id}"
      if entry.allow_delete?
        assert_select 'a[class~="delete"]'
      else
        assert_select 'button[class~="delete"]'
      end
    end
  end
end
