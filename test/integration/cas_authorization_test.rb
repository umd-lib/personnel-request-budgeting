require 'test_helper'

# Integration test for CAS authorization functionality
class CasAuthorizationTest < ActionDispatch::IntegrationTest
  test 'existing user can access application' do
    CASClient::Frameworks::Rails::Filter.fake(DEFAULT_TEST_USER)

    get root_path
    assert_template 'static_pages/index'
  end

  test 'non-existent user cannot access application' do
    CASClient::Frameworks::Rails::Filter.fake('no_such_user')

    get root_path
    assert_response(:forbidden)
  end

  def teardown
    # Restore normal "test_user"
    CASClient::Frameworks::Rails::Filter.fake(DEFAULT_TEST_USER)
  end
end
