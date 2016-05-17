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
    get :show, id: @user
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @user
    assert_response :success
  end

  test 'should update user' do
    patch :update, id: @user, user: { cas_directory_id: @user.cas_directory_id, name: @user.name }
    assert_redirected_to user_path(assigns(:user))
  end

  test 'should destroy user' do
    user = User.new(cas_directory_id: 'SAMPLE_USER', name: 'Sample User')
    user.save!
    assert_difference('User.count', -1) do
      delete :destroy, id: user
    end

    assert_redirected_to users_path
  end
end
