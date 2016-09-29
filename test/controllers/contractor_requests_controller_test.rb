require 'test_helper'

class ContractorRequestsControllerTest < ActionController::TestCase
  setup do
    @contractor_request = contractor_requests(:c2)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:contractor_requests)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create contractor_request' do
    assert_difference('ContractorRequest.count') do
      post :create, contractor_request: {
        annual_base_pay: @contractor_request.annual_base_pay,
        contractor_name: @contractor_request.contractor_name,
        department_id: @contractor_request.department_id,
        employee_type_id: @contractor_request.employee_type_id,
        justification: @contractor_request.justification,
        nonop_funds: @contractor_request.nonop_funds,
        nonop_source: @contractor_request.nonop_source,
        number_of_months: @contractor_request.number_of_months,
        position_description: @contractor_request.position_description,
        request_type_id: @contractor_request.request_type_id,
        unit_id: @contractor_request.unit_id }
    end

    assert_redirected_to contractor_request_path(assigns(:contractor_request))
  end

  test 'should not create invalid contractor_request' do
    assert_no_difference('ContractorRequest.count') do
      post :create, contractor_request: {
        annual_base_pay: nil,
        contractor_name: nil,
        department_id: nil,
        employee_type_id: nil,
        justification: nil,
        nonop_funds: nil,
        nonop_source: nil,
        number_of_months: nil,
        position_description: nil,
        request_type_id: nil,
        unit_id: nil }
    end
  end

  test 'should show contractor_request' do
    get :show, id: @contractor_request
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @contractor_request
    assert_response :success
  end

  test 'should create/update contractor_request but without admin only values when not admin' do
    run_as_user(users(:test_not_admin_with_dept)) do
      assert_difference('ContractorRequest.count') do
        post :create, contractor_request: {
          annual_base_pay: @contractor_request.annual_base_pay,
          contractor_name: @contractor_request.contractor_name,
          department_id: @contractor_request.department_id,
          employee_type_id: @contractor_request.employee_type_id,
          justification: @contractor_request.justification,
          nonop_funds: @contractor_request.nonop_funds,
          nonop_source: @contractor_request.nonop_source,
          number_of_months: @contractor_request.number_of_months,
          position_description: @contractor_request.position_description,
          request_type_id: @contractor_request.request_type_id,
          review_status_id: review_statuses(:approved).id, # Should be ignored
          review_comment: 'Lorem ipsum facto', # Should be ignored
          unit_id: @contractor_request.unit_id }
      end
      assert_redirected_to contractor_request_path(assigns(:contractor_request))
      assert_equal review_statuses(:under_review).id, assigns(:contractor_request).review_status_id
      assert_equal nil, assigns(:contractor_request).review_comment

      patch :update, id: assigns(:contractor_request).id,
                     contractor_request: assigns(:contractor_request).attributes.merge(
                       review_comment: 'come on mang', review_status_id: 100)

      assert_redirected_to contractor_request_path(assigns(:contractor_request))
      assert_equal review_statuses(:under_review).id, assigns(:contractor_request).review_status_id
      assert_equal nil, assigns(:contractor_request).review_comment
      assert_equal @contractor_request.contractor_name, assigns(:contractor_request).contractor_name
    end
  end

  test 'should update contractor_request' do
    patch :update, id: @contractor_request, contractor_request: {
      annual_base_pay: @contractor_request.annual_base_pay,
      contractor_name: @contractor_request.contractor_name,
      department_id: @contractor_request.department_id,
      employee_type_id: @contractor_request.employee_type_id,
      justification: @contractor_request.justification,
      nonop_funds: @contractor_request.nonop_funds,
      nonop_source: @contractor_request.nonop_source,
      number_of_months: @contractor_request.number_of_months,
      position_description: @contractor_request.position_description,
      request_type_id: @contractor_request.request_type_id,
      unit_id: @contractor_request.unit_id }
    assert_redirected_to contractor_request_path(assigns(:contractor_request))
  end

  test 'should not update invalid contractor_request' do
    original_attrs = @contractor_request.attributes
    patch :update, id: @contractor_request, contractor_request: {
      annual_base_pay: nil,
      contractor_name: nil,
      department_id: nil,
      employee_type_id: nil,
      justification: nil,
      nonop_funds: nil,
      nonop_source: nil,
      number_of_months: nil,
      position_description: nil,
      request_type_id: nil,
      unit_id: nil }
    assert_equal original_attrs, ContractorRequest.find(@contractor_request.id).attributes
  end

  test 'should destroy contractor_request' do
    assert_difference('ContractorRequest.count', -1) do
      delete :destroy, id: @contractor_request
    end

    assert_redirected_to contractor_requests_path
  end
end
