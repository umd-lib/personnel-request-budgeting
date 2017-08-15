require 'test_helper'

# Tests for PersonnelRequestPolicy's Scope class
# These tests only cover visibility of the personnel requests, not the
# actions that can be taken on them.
class RequestPolicyScopeTest < ActiveSupport::TestCase

  test 'personnel requests have records' do
    # Without records, all the rest of the tests are probably meaningless
    assert Request.count > 0
  end

  test 'user without role cannot see any personnel requests' do
    with_temp_user do |temp_user| 
      assert_equal 0, Pundit.policy_scope!(temp_user, LaborRequest).count
      assert_equal 0, Pundit.policy_scope!(temp_user, StaffRequest).count
      assert_equal 0, Pundit.policy_scope!(temp_user, ContractorRequest).count
    end
  end

  test 'admin role can see all personnel requests' do
    with_temp_user(admin: true) do |temp_user|
      assert_equal LaborRequest.count, Pundit.policy_scope!(temp_user, LaborRequest).count
      assert_equal StaffRequest.count, Pundit.policy_scope!(temp_user, StaffRequest).count
      assert_equal ContractorRequest.all.count, Pundit.policy_scope!(temp_user, ContractorRequest).count
    end
  end

  test 'department role can only see department personnel requests' do
    department = Organization.find_by( organization_type: Organization.organization_types["department"] ) 
    with_temp_user(roles: [department]) do |temp_user|
      
      labor_results = Pundit.policy_scope!(temp_user, LaborRequest)
      staff_results = Pundit.policy_scope!(temp_user, StaffRequest)
      contractor_results = Pundit.policy_scope!(temp_user, ContractorRequest)

      record_count = labor_results.count + staff_results.count + contractor_results.count
      assert record_count > 0, "No records found for department '#{department.code}'"

      [labor_results, staff_results, contractor_results].each do |requests|
        requests.each do |r|
          assert_equal department.code, r.organization.code
        end
      end
    end
  end
  
  test 'unit role can only see unit personnel requests' do
    unit = Organization.find_by( organization_type: Organization.organization_types["unit"] ) 
    with_temp_user(roles: [unit]) do |temp_user|
      
      labor_results = Pundit.policy_scope!(temp_user, LaborRequest)
      staff_results = Pundit.policy_scope!(temp_user, StaffRequest)
      contractor_results = Pundit.policy_scope!(temp_user, ContractorRequest)

      record_count = labor_results.count + staff_results.count + contractor_results.count
      assert record_count > 0, "No records found for department '#{unit.code}'"

      [labor_results, staff_results, contractor_results].each do |requests|
        requests.each do |r|
          assert_equal unit.code, r.organization.code
        end
      end
    end
  end

  test 'multi-department user can only see personnel requests from those departments' do
   
    d1, d2 = Organization.where( organization_type: Organization.organization_types["department"]).limit(2)
    
    with_temp_user(roles: [d1, d2]) do |temp_user|
      labor_results = Pundit.policy_scope!(temp_user, LaborRequest)
      staff_results = Pundit.policy_scope!(temp_user, StaffRequest)
      contractor_results = Pundit.policy_scope!(temp_user, ContractorRequest)

      [labor_results, staff_results, contractor_results].each do |requests|
        requests.each do |r|
          assert_includes [ d1.code, d2.code ],
                          r.organization.code
        end
      end
    end
  end

  test 'mixed department and unit user can only see personnel requests from that department or unit' do
    d = Organization.find_by( organization_type: Organization.organization_types["department"])
    u = Organization.find_by( organization_type: Organization.organization_types["unit"])
    with_temp_user(roles: [ d, u ]) do |temp_user|
      labor_results = Pundit.policy_scope!(temp_user, LaborRequest)
      staff_results = Pundit.policy_scope!(temp_user, StaffRequest)
      contractor_results = Pundit.policy_scope!(temp_user, ContractorRequest)

      [labor_results, staff_results, contractor_results].each do |requests|
        requests.each do |r|
          if r.organization.organization_type == "department"
            assert_equal d.code, r.organization.code
          else
            assert_equal u.code, r.organization.code
          end
        end
      end
    end
  end
end
