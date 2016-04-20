require 'test_helper'

class DepartmentsControllerTest < ActionController::TestCase
  setup do
    @department = departments(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:departments)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create department' do
    assert_difference('Department.count') do
      post :create, department:
        { code: 'NEW_DEPT', division_id: @department.division_id, name: @department.name }
    end

    assert_redirected_to department_path(assigns(:department))
  end

  test 'should show department' do
    get :show, id: @department
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @department
    assert_response :success
  end

  test 'should update department' do
    patch :update, id: @department, department: { division_id: @department.division_id, name: @department.name }
    assert_redirected_to department_path(assigns(:department))
  end

  test 'should destroy department' do
    department = Department.new(code: 'TEST_DEPT', name: 'Test Department',
                                division_id: @department.division_id)
    department.save!
    assert_equal true, department.allow_delete?
    assert_difference('Department.count', -1) do
      delete :destroy, id: department
    end

    assert_redirected_to departments_path
  end

  test 'should show error when cannot destroy department with associated records' do
    assert_equal false, @department.allow_delete?
    assert_no_difference('Department.count') do
      delete :destroy, id: @department
    end
    assert !flash.empty?

    assert_redirected_to departments_path
  end
end
