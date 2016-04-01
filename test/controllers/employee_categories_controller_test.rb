require 'test_helper'

class EmployeeCategoriesControllerTest < ActionController::TestCase
  setup do
    @employee_category = employee_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employee_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee_category" do
    assert_difference('EmployeeCategory.count') do
      post :create, employee_category: { code: @employee_category.code, name: @employee_category.name }
    end

    assert_redirected_to employee_category_path(assigns(:employee_category))
  end

  test "should show employee_category" do
    get :show, id: @employee_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee_category
    assert_response :success
  end

  test "should update employee_category" do
    patch :update, id: @employee_category, employee_category: { code: @employee_category.code, name: @employee_category.name }
    assert_redirected_to employee_category_path(assigns(:employee_category))
  end

  test "should destroy employee_category" do
    assert_difference('EmployeeCategory.count', -1) do
      delete :destroy, id: @employee_category
    end

    assert_redirected_to employee_categories_path
  end
end
