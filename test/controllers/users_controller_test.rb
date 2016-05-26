require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post :create, user: { cas_directory_id: 'NEW_USER', name: 'New User' }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test 'should show user' do
    admin_user = users(:test_admin)
    CASClient::Frameworks::Rails::Filter.fake(admin_user.cas_directory_id)

    get :show, id: @user
    assert_response :success

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end

  test 'should get edit' do
    admin_user = users(:test_admin)
    CASClient::Frameworks::Rails::Filter.fake(admin_user.cas_directory_id)

    get :edit, id: @user
    assert_response :success

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end

  test 'should update user' do
    admin_user = users(:test_admin)
    CASClient::Frameworks::Rails::Filter.fake(admin_user.cas_directory_id)

    patch :update, id: @user, user: { cas_directory_id: @user.cas_directory_id, name: @user.name }
    assert_redirected_to user_path(assigns(:user))

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end

  test 'should destroy user' do
    user = User.new(cas_directory_id: 'SAMPLE_USER', name: 'Sample User')
    user.save!
    assert_difference('User.count', -1) do
      delete :destroy, id: user
    end

    assert_redirected_to users_path
  end

  test 'allow access by non-admin user to see and edit own entry' do
    not_admin_user = users(:test_not_admin)
    CASClient::Frameworks::Rails::Filter.fake(not_admin_user.cas_directory_id)

    get :show, id: not_admin_user
    assert_response :success

    get :edit, id: not_admin_user
    assert_response :success

    patch :update, id: not_admin_user,
                   user: { cas_directory_id: not_admin_user.cas_directory_id,
                           name: not_admin_user.name }
    assert_redirected_to user_path(not_admin_user)

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end

  test 'forbid access by non-admin user' do
    not_admin_user = users(:test_not_admin)
    CASClient::Frameworks::Rails::Filter.fake(not_admin_user.cas_directory_id)
    get :index
    assert_response :forbidden

    get :new
    assert_response :forbidden

    get :show, id: @user
    assert_response :forbidden

    get :edit, id: @user
    assert_response :forbidden

    post :create, user: { cas_directory_id: 'NEW_USER', name: 'New User' }
    assert_response :forbidden

    patch :update, id: @user, user: { cas_directory_id: @user.cas_directory_id, name: @user.name }
    assert_response :forbidden

    delete :destroy, id: @user
    assert_response :forbidden

    # Restore fake user
    CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
  end
end
