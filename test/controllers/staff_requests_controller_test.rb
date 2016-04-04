require 'test_helper'

class StaffRequestsControllerTest < ActionController::TestCase
  setup do
    @staff_request = staff_requests(:fac)
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
        position_description: @staff_request.position_description,
        request_type_id: @staff_request.request_type_id,
        subdepartment_id: @staff_request.subdepartment_id }
    end

    assert_redirected_to staff_request_path(assigns(:staff_request))
  end

  test 'should show staff_request' do
    get :show, id: @staff_request
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @staff_request
    assert_response :success
  end

  test 'should update staff_request' do
    patch :update, id: @staff_request, staff_request: {
      annual_base_pay: @staff_request.annual_base_pay,
      department_id: @staff_request.department_id,
      employee_type_id: @staff_request.employee_type_id,
      justification: @staff_request.justification,
      nonop_funds: @staff_request.nonop_funds,
      nonop_source: @staff_request.nonop_source,
      position_description: @staff_request.position_description,
      request_type_id: @staff_request.request_type_id,
      subdepartment_id: @staff_request.subdepartment_id }
    assert_redirected_to staff_request_path(assigns(:staff_request))
  end

  test 'should destroy staff_request' do
    assert_difference('StaffRequest.count', -1) do
      delete :destroy, id: @staff_request
    end

    assert_redirected_to staff_requests_path
  end
end
