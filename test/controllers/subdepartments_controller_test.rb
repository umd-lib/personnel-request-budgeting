require 'test_helper'

class SubdepartmentsControllerTest < ActionController::TestCase
  setup do
    @subdepartment = subdepartments(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:subdepartments)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create subdepartment' do
    assert_difference('Subdepartment.count') do
      post :create, subdepartment: {
        code: 'NEW_SUBDEPT', department_id: @subdepartment.department_id, name: @subdepartment.name }
    end

    assert_redirected_to subdepartment_path(assigns(:subdepartment))
  end

  test 'should show subdepartment' do
    get :show, id: @subdepartment
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @subdepartment
    assert_response :success
  end

  test 'should update subdepartment' do
    patch :update, id: @subdepartment, subdepartment: {
      code: @subdepartment.code, department_id: @subdepartment.department_id, name: @subdepartment.name }
    assert_redirected_to subdepartment_path(assigns(:subdepartment))
  end

  test 'should destroy subdepartment' do
    subdepartment = Subdepartment.new(code: 'TEST_SUBDEPT', name: 'Test Subdepartment',
                                      department: @subdepartment.department)
    subdepartment.save!
    assert_difference('Subdepartment.count', -1) do
      delete :destroy, id: subdepartment
    end

    assert_redirected_to subdepartments_path
  end

  test 'should show error when cannot destroy subdepartment with associated records' do
    staff_request = staff_requests(:fac)
    staff_request.department = @subdepartment.department
    staff_request.subdepartment = @subdepartment
    staff_request.save!
    assert_equal false, @subdepartment.allow_delete?

    assert_no_difference('Subdepartment.count') do
      delete :destroy, id: @subdepartment
    end
    assert !flash.empty?

    assert_redirected_to subdepartments_path
  end
end
