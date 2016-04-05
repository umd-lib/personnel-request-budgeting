require 'test_helper'

class ContractorRequestsControllerTest < ActionController::TestCase
  setup do
    @contractor_request = contractor_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contractor_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contractor_request" do
    assert_difference('ContractorRequest.count') do
      post :create, contractor_request: { annual_base_pay: @contractor_request.annual_base_pay, contractor_name: @contractor_request.contractor_name, department_id: @contractor_request.department_id, employee_type_id: @contractor_request.employee_type_id, justification: @contractor_request.justification, nonop_funds: @contractor_request.nonop_funds, nonop_source: @contractor_request.nonop_source, number_of_months: @contractor_request.number_of_months, position_description: @contractor_request.position_description, request_type_id: @contractor_request.request_type_id, subdepartment_id: @contractor_request.subdepartment_id }
    end

    assert_redirected_to contractor_request_path(assigns(:contractor_request))
  end

  test "should show contractor_request" do
    get :show, id: @contractor_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contractor_request
    assert_response :success
  end

  test "should update contractor_request" do
    patch :update, id: @contractor_request, contractor_request: { annual_base_pay: @contractor_request.annual_base_pay, contractor_name: @contractor_request.contractor_name, department_id: @contractor_request.department_id, employee_type_id: @contractor_request.employee_type_id, justification: @contractor_request.justification, nonop_funds: @contractor_request.nonop_funds, nonop_source: @contractor_request.nonop_source, number_of_months: @contractor_request.number_of_months, position_description: @contractor_request.position_description, request_type_id: @contractor_request.request_type_id, subdepartment_id: @contractor_request.subdepartment_id }
    assert_redirected_to contractor_request_path(assigns(:contractor_request))
  end

  test "should destroy contractor_request" do
    assert_difference('ContractorRequest.count', -1) do
      delete :destroy, id: @contractor_request
    end

    assert_redirected_to contractor_requests_path
  end
end
