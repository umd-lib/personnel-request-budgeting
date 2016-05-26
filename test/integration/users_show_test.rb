require 'test_helper'

# Integration test for the User show page
class UsersShowTest < ActionDispatch::IntegrationTest
  test 'list all button is available' do
    user_to_show = users(:test_not_admin)

    get user_path(user_to_show)
    assert_select "[href='/users']"
  end

  test 'list all button is not available for non-admin user' do
    user_to_show = users(:test_not_admin)

    run_as_user(user_to_show) do
      get user_path(user_to_show)
      assert_select "[href='/users']", false
    end
  end
end
