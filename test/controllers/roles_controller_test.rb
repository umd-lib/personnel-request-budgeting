require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  setup do
    @role = roles(:one_with_department)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create role' do
    assert_difference('Role.count') do
      post :create, role: {
        user_id: users(:two),
        role_type_id: role_types(:department),
        department_id: departments(:ssdr) }
    end

    assert_redirected_to role_path(assigns(:role))
  end

  test 'should show role' do
    get :show, id: @role
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @role
    assert_response :success
  end

  test 'should update role' do
    patch :update, id: @role, role: {
      department_id: departments(:uss),
      role_type_id: @role.role_type_id }
    assert_redirected_to role_path(assigns(:role))
  end

  test 'should destroy role' do
    assert_difference('Role.count', -1) do
      delete :destroy, id: @role
    end

    assert_redirected_to roles_path
  end

  test 'forbid access by non-admin user' do
    run_as_user(users(:test_not_admin)) do
      get :index
      assert_response :forbidden

      get :new
      assert_response :forbidden

      get :show, id: @role
      assert_response :forbidden

      get :edit, id: @role
      assert_response :forbidden

      post :create, role: {
        user_id: users(:two),
        role_type_id: role_types(:department),
        department_id: departments(:ssdr) }
      assert_response :forbidden

      patch :update, id: @role, role: {
        department_id: departments(:uss),
        role_type_id: @role.role_type_id }
      assert_response :forbidden

      delete :destroy, id: @role
      assert_response :forbidden
    end
  end
end
