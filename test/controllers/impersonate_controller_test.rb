require 'test_helper'

class ImpersonateControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'create should impersonate user' do
    @admin_user = users(:test_admin)
    @impersonated_user = users(:one)
    run_as_user(@admin_user) do
      get :create, user_id: @impersonated_user
      assert_not_nil session[ImpersonateController::IMPERSONATE_USER_PARAM]
      assert_equal session[ImpersonateController::IMPERSONATE_USER_PARAM], @impersonated_user.id
    end
  end

  test 'destroy should stop impersonate user' do
    @admin_user = users(:test_admin)
    @impersonated_user = users(:one)
    run_as_user(@admin_user) do
      get :create, user_id: @impersonated_user
      assert_not_nil session[ImpersonateController::IMPERSONATE_USER_PARAM]
      assert_equal session[ImpersonateController::IMPERSONATE_USER_PARAM], @impersonated_user.id

      delete :destroy
      assert_nil session[ImpersonateController::IMPERSONATE_USER_PARAM]
    end
  end

  test 'forbid access by non-admin user' do
    @impersonated_user = users(:one)
    run_as_user(users(:test_not_admin)) do
      get :index
      assert_response :forbidden

      get :create, user_id: @impersonated_user
      assert_response :forbidden
    end
  end

  test 'access allowed to destroy by non-admin user' do
    run_as_user(users(:test_not_admin)) do
      delete :destroy
      assert_redirected_to root_path
    end
  end
end
