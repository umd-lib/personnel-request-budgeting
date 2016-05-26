require 'test_helper'

# Integration test for the StaffRequest show page
class StaticPagesIndexTest < ActionDispatch::IntegrationTest
  test 'admin menu visible' do
    get root_path
    assert_select 'li[id="admin_menu"]'
  end

  test 'admin section visible' do
    get root_path
    assert_select 'div[id="admin_panel_heading"]'
    assert_select 'div[id="admin_panel_body"]'
  end

  test 'admin menu not visible for non-admin user' do
    run_as_user(users(:test_not_admin)) do
      get root_path
      assert_select 'li[id="admin_menu"]', false
    end
  end

  test 'admin section not visible for non-admin user' do
    run_as_user(users(:test_not_admin)) do
      get root_path
      assert_select 'div[id="admin_panel_heading"]', false
      assert_select 'div[id="admin_panel_body"]', false
    end
  end
end
