require 'test_helper'

class EmployeeTypesControllerTest < ActionController::TestCase
  setup do
    @emp_type = employee_types(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_types)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create employee_type' do
    assert_difference('EmployeeType.count') do
      post :create, employee_type: {
        code: 'NEW_EMP_TYPE', name: @emp_type.name, employee_category_id: @emp_type.employee_category_id }
    end

    assert_redirected_to employee_type_path(assigns(:employee_type))
  end

  test 'should show employee_type' do
    get :show, id: @emp_type
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @emp_type
    assert_response :success
  end

  test 'should update employee_type' do
    patch :update, id: @emp_type, employee_type: {
      code: @emp_type.code, name: @emp_type.name, employee_category_id: @emp_type.employee_category_id }
    assert_redirected_to employee_type_path(assigns(:employee_type))
  end

  test 'should destroy employee_type' do
    assert_difference('EmployeeType.count', -1) do
      delete :destroy, id: @emp_type
    end

    assert_redirected_to employee_types_path
  end
end
