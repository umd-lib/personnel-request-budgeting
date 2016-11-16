require 'test_helper'

# Integration test for the Impersonate index page
class LogoutTest < ActionDispatch::IntegrationTest
  test 'Logout the user' do

    # Verify sorting
    admin = users(:test_admin)
    run_as_user(admin) do
      get "/" 
      assert_select "a", admin.name 
      get logout_path
      assert_select 'h1', "Signed Out"
      assert_select "a", { count: 0, text: admin.name } 
    end 
  end
end
