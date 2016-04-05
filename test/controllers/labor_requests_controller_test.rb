require 'test_helper'

class LaborRequestsControllerTest < ActionController::TestCase
  setup do
    @labor_request = labor_requests(:c1)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:labor_requests)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create labor_request' do
    assert_difference('LaborRequest.count') do
      post :create, labor_request: {
        contractor_name: @labor_request.contractor_name,
        department_id: @labor_request.department_id,
        employee_type_id: @labor_request.employee_type_id,
        hourly_rate: @labor_request.hourly_rate,
        hours_per_week: @labor_request.hours_per_week,
        justification: @labor_request.justification,
        nonop_funds: @labor_request.nonop_funds,
        nonop_source: @labor_request.nonop_source,
        number_of_positions: @labor_request.number_of_positions,
        number_of_weeks: @labor_request.number_of_weeks,
        position_description: @labor_request.position_description,
        request_type_id: @labor_request.request_type_id,
        subdepartment_id: @labor_request.subdepartment_id }
    end

    assert_redirected_to labor_request_path(assigns(:labor_request))
  end

  test 'should show labor_request' do
    get :show, id: @labor_request
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @labor_request
    assert_response :success
  end

  test 'should update labor_request' do
    patch :update, id: @labor_request, labor_request: {
      contractor_name: @labor_request.contractor_name,
      department_id: @labor_request.department_id,
      employee_type_id: @labor_request.employee_type_id,
      hourly_rate: @labor_request.hourly_rate,
      hours_per_week: @labor_request.hours_per_week,
      justification: @labor_request.justification,
      nonop_funds: @labor_request.nonop_funds,
      nonop_source: @labor_request.nonop_source,
      number_of_positions: @labor_request.number_of_positions,
      number_of_weeks: @labor_request.number_of_weeks,
      position_description: @labor_request.position_description,
      request_type_id: @labor_request.request_type_id,
      rubocopsubdepartment_id: @labor_request.subdepartment_id }
    assert_redirected_to labor_request_path(assigns(:labor_request))
  end

  test 'should destroy labor_request' do
    assert_difference('LaborRequest.count', -1) do
      delete :destroy, id: @labor_request
    end

    assert_redirected_to labor_requests_path
  end
end
