require 'test_helper'

# Integration test for Personnel Request Policy
class PersonnelRequestPolicyIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @dept1 = departments_with_records[0]
    @dept2 = departments_with_records[1]


    @dept1_user = User.create(cas_directory_id: 'dept1', name: 'Dept1 User')
    Role.create!(user: @dept1_user,
                 role_type: RoleType.find_by_code('department'),
                 department: @dept1)
  end

  def teardown
    Role.destroy_all(user: @dept1_user)
    @dept1_user.destroy!
  end

  def test_verify_authorization_in_controller
    run_as_user(@dept1_user) do
      dept1_request = LaborRequest.where(department: @dept1)[0]
      dept2_request = LaborRequest.where(department: @dept2)[0]

      # Show
      get labor_request_path(dept1_request)
      assert_response :success

      get labor_request_path(dept2_request)
      assert_response :forbidden

      # New

      # Edit
      get edit_labor_request_path(dept1_request)
      assert_response :success

      get edit_labor_request_path(dept2_request)
      assert_response :forbidden

      # Create
      post labor_requests_path, labor_request: {
        contractor_name: dept1_request.contractor_name,
        department_id: dept1_request.department_id,
        employee_type_id: dept1_request.employee_type_id,
        hourly_rate: dept1_request.hourly_rate,
        hours_per_week: dept1_request.hours_per_week,
        justification: dept1_request.justification,
        nonop_funds: dept1_request.nonop_funds,
        nonop_source: dept1_request.nonop_source,
        number_of_positions: dept1_request.number_of_positions,
        number_of_weeks: dept1_request.number_of_weeks,
        position_description: dept1_request.position_description,
        request_type_id: dept1_request.request_type_id,
        unit_id: dept1_request.unit_id }
      assert_redirected_to labor_request_path(assigns(:labor_request))

      post labor_requests_path, labor_request: {
        contractor_name: dept2_request.contractor_name,
        department_id: dept2_request.department_id,
        employee_type_id: dept2_request.employee_type_id,
        hourly_rate: dept2_request.hourly_rate,
        hours_per_week: dept2_request.hours_per_week,
        justification: dept2_request.justification,
        nonop_funds: dept2_request.nonop_funds,
        nonop_source: dept2_request.nonop_source,
        number_of_positions: dept2_request.number_of_positions,
        number_of_weeks: dept2_request.number_of_weeks,
        position_description: dept2_request.position_description,
        request_type_id: dept2_request.request_type_id,
        unit_id: dept2_request.unit_id }
      assert_response :forbidden

      # Update
      patch labor_request_path(dept1_request), labor_request: { position_description: 'Foo' }
      assert_redirected_to labor_request_path(dept1_request)

      patch labor_request_path(dept2_request),labor_request: { position_description: 'Foo' }
      assert_response :forbidden

      # Destroy
      delete labor_request_path(dept1_request)
      assert_redirected_to labor_requests_url

      delete labor_request_path(dept2_request)
      assert_response :forbidden
    end
  end

end
