require 'test_helper'

# Integration test for the StaffRequest show page
class StaticPagesIndexTest < ActionDispatch::IntegrationTest

  test 'admin menu visible for admin user' do
    admin_user = users(:test_admin)
    CASClient::Frameworks::Rails::Filter.fake(admin_user.cas_directory_id)

    get root_path
    assert_select 'li[id="admin_menu"]'

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end

  test 'admin menu not visible for non-admin user' do
    not_admin_user = users(:test_not_admin)
    CASClient::Frameworks::Rails::Filter.fake(not_admin_user.cas_directory_id)

    get root_path
    assert_select 'li[id="admin_menu"]', false

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end


  test 'admin section visible for admin user' do
    admin_user = users(:test_admin)
    CASClient::Frameworks::Rails::Filter.fake(admin_user.cas_directory_id)

    get root_path
    assert_select 'div[id="admin_panel_heading"]'
    assert_select 'div[id="admin_panel_body"]'

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end

  test 'admin section not visible for non-admin user' do
    not_admin_user = users(:test_not_admin)
    CASClient::Frameworks::Rails::Filter.fake(not_admin_user.cas_directory_id)

    get root_path
    assert_select 'div[id="admin_panel_heading"]', false
    assert_select 'div[id="admin_panel_body"]', false

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end

end