require 'test_helper'

class RoleTypesControllerTest < ActionController::TestCase
  setup do
    @role_type = role_types(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:role_types)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create role_type' do
    assert_difference('RoleType.count') do
      post :create, role_type: { code: 'NEW_ROLE_TYPE', name: @role_type.name }
    end

    assert_redirected_to role_type_path(assigns(:role_type))
  end

  test 'should show role_type' do
    get :show, id: @role_type
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @role_type
    assert_response :success
  end

  test 'should update role_type' do
    patch :update, id: @role_type, role_type: { code: @role_type.code, name: @role_type.name }
    assert_redirected_to role_type_path(assigns(:role_type))
  end

  test 'should destroy role_type' do
    # Role type "two" does not have a role_cutoff, so if can be deleted.
    role_type = role_types(:two)
    assert_equal true, role_type.allow_delete?
    assert_difference('RoleType.count', -1) do
      delete :destroy, id: role_type
    end

    assert_redirected_to role_types_path
  end

  test 'should show error when cannot destroy role type with associated records' do
    role_type = role_types(:admin)
    assert_equal false, role_type.allow_delete?
    assert_no_difference('RoleType.count') do
      delete :destroy, id: role_type
    end
    assert !flash.empty?

    assert_redirected_to role_types_path
  end

  test 'forbid access by non-admin user' do
    run_as_user(users(:test_not_admin)) do
      get :index
      assert_response :forbidden

      get :new
      assert_response :forbidden

      get :show, id: @role_type
      assert_response :forbidden

      get :edit, id: @role_type
      assert_response :forbidden

      post :create, role_type: { code: 'NEW_ROLE_TYPE', name: @role_type.name }
      assert_response :forbidden

      patch :update, id: @role_type, role_type: { code: @role_type.code, name: @role_type.name }
      assert_response :forbidden

      delete :destroy, id: @role_type
      assert_response :forbidden
    end
  end
end
