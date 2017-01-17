require 'test_helper'

# Integration test for CAS authorization functionality
class CasAuthorizationTest < ActionDispatch::IntegrationTest
  test 'user should be redirected to login page when not logged in' do
    CASClient::Frameworks::Rails::Filter.fake(nil)

    get root_path
    assert_redirected_to %r(\Ahttps://login.umd.edu/cas/login)
  end

  test 'ping service can be accessed without logging in' do
    CASClient::Frameworks::Rails::Filter.fake(nil)

    get '/ping'
    assert_response(:success)
  end

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
