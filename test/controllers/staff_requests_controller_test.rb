require 'test_helper'

class StaffRequestsControllerTest < ActionController::TestCase
  setup do
    @staff_request = staff_requests(:fac)
    @staff_request_with_status = staff_requests(:staff_request_with_status)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:staff_requests)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'employee type dropdown should only show valid types on new' do
    get :new

    valid_employee_category_code = StaffRequest::VALID_EMPLOYEE_CATEGORY_CODE
    assert_select 'select#staff_request_employee_type_id option' do |options|
      options.each do |option|
        next if option.attribute('value').value.blank? # Skip drop-down prompt
        emp_type = EmployeeType.find_by_name(option.inner_text)
        assert_equal valid_employee_category_code, emp_type.employee_category.code,
                     "'#{option.inner_text}' option is not of category '#{valid_employee_category_code}'"
      end
    end
  end

  test 'should create staff_request' do
    assert_difference('StaffRequest.count') do
      post :create, staff_request: {
        annual_base_pay: @staff_request.annual_base_pay,
        department_id: @staff_request.department_id,
        employee_type_id: @staff_request.employee_type_id,
        justification: @staff_request.justification,
        nonop_funds: @staff_request.nonop_funds,
        nonop_source: @staff_request.nonop_source,
        position_title: @staff_request.position_title,
        request_type_id: @staff_request.request_type_id,
        unit_id: @staff_request.unit_id }
    end

    assert_redirected_to staff_request_path(assigns(:staff_request))
  end

  test 'should not create invalid staff_request' do
    assert_no_difference('StaffRequest.count') do
      post :create, staff_request: {
        annual_base_pay: nil,
        department_id: nil,
        employee_type_id: nil,
        justification: nil,
        nonop_funds: nil,
        nonop_source: nil,
        position_title: nil,
        request_type_id: nil,
        unit_id: nil }
    end
  end

  test 'should show staff_request' do
    get :show, id: @staff_request
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @staff_request
    assert_response :success
  end

  test 'should create/update staff_request but without admin only values when not admin' do
    run_as_user(users(:test_not_admin_with_dept)) do
      assert_difference('StaffRequest.count') do
        post :create, staff_request: {
          annual_base_pay: @staff_request_with_status.annual_base_pay,
          department_id: @staff_request_with_status.department_id,
          employee_type_id: @staff_request_with_status.employee_type_id,
          justification: @staff_request_with_status.justification,
          nonop_funds: @staff_request_with_status.nonop_funds,
          nonop_source: @staff_request_with_status.nonop_source,
          position_title: @staff_request_with_status.position_title,
          request_type_id: @staff_request_with_status.request_type_id,
          review_status_id: review_statuses(:approved).id, # Should be ignored
          review_comment: 'Lorem ipsum facto', # Should be ignored
          unit_id: @staff_request_with_status.unit_id }
      end
      assert_redirected_to staff_request_path(assigns(:staff_request))
      assert_equal review_statuses(:under_review).id, assigns(:staff_request).review_status_id
      assert_nil assigns(:staff_request).review_comment

      patch :update, id: assigns(:staff_request).id,
                     staff_request: assigns(:staff_request).attributes.merge(
                       review_comment: 'come on mang', review_status_id: 100)

      assert_redirected_to staff_request_path(assigns(:staff_request))
      assert_equal review_statuses(:under_review).id, assigns(:staff_request).review_status_id
      assert_nil assigns(:staff_request).review_comment
      assert_equal @staff_request_with_status.annual_base_pay, assigns(:staff_request).annual_base_pay
    end
  end

  test 'should update staff_request' do
    patch :update, id: @staff_request, staff_request: {
      annual_base_pay: @staff_request.annual_base_pay,
      department_id: @staff_request.department_id,
      employee_type_id: @staff_request.employee_type_id,
      justification: @staff_request.justification,
      nonop_funds: @staff_request.nonop_funds,
      nonop_source: @staff_request.nonop_source,
      position_title: @staff_request.position_title,
      request_type_id: @staff_request.request_type_id,
      unit_id: @staff_request.unit_id }
    assert_redirected_to staff_request_path(assigns(:staff_request))
  end

  test 'should not update invalid staff_request' do
    original_attrs = @staff_request.attributes
    patch :update, id: @staff_request, staff_request: {
      annual_base_pay: nil,
      department_id: nil,
      employee_type_id: nil,
      justification: nil,
      nonop_funds: nil,
      nonop_source: nil,
      position_title: nil,
      request_type_id: nil,
      unit_id: nil }
    assert_equal original_attrs, StaffRequest.find(@staff_request.id).attributes
  end

  test 'should destroy staff_request' do
    assert_difference('StaffRequest.count', -1) do
      delete :destroy, id: @staff_request
    end

    assert_redirected_to staff_requests_path
  end
end
