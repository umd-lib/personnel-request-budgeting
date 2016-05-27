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
