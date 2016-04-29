require 'test_helper'

class UnitsControllerTest < ActionController::TestCase
  setup do
    @unit = units(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:units)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create unit' do
    assert_difference('Unit.count') do
      post :create, unit: {
        code: 'NEW_UNIT', department_id: @unit.department_id, name: @unit.name }
    end

    assert_redirected_to unit_path(assigns(:unit))
  end

  test 'should show unit' do
    get :show, id: @unit
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @unit
    assert_response :success
  end

  test 'should update unit' do
    patch :update, id: @unit, unit: {
      code: @unit.code, department_id: @unit.department_id, name: @unit.name }
    assert_redirected_to unit_path(assigns(:unit))
  end

  test 'should destroy unit' do
    unit = Unit.new(code: 'TEST_UNIT', name: 'Test Unit',
                    department: @unit.department)
    unit.save!
    assert_difference('Unit.count', -1) do
      delete :destroy, id: unit
    end

    assert_redirected_to units_path
  end

  test 'should show error when cannot destroy unit with associated records' do
    staff_request = staff_requests(:fac)
    staff_request.department = @unit.department
    staff_request.unit = @unit
    staff_request.save!
    assert_equal false, @unit.allow_delete?

    assert_no_difference('Unit.count') do
      delete :destroy, id: @unit
    end
    assert !flash.empty?

    assert_redirected_to units_path
  end
end
