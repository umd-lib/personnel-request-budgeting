require 'test_helper'

# Integration test for the User edit page
class UsersEditTest < ActionDispatch::IntegrationTest
  test 'list all button is available' do
    user_to_edit = users(:test_not_admin)

    get edit_user_path(user_to_edit)
    assert_select "[href='/users']"
  end

  test 'list all button is not available for non-admin user' do
    user_to_edit = users(:test_not_admin)

    run_as_user(user_to_edit) do
      get edit_user_path(user_to_edit)
      assert_select "[href='/users']", false
    end
  end
end
