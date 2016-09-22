require 'test_helper'

# Tests for PersonnelRequestPolicy's Scope class
# These tests only cover visibility of the personnel requests, not the
# actions that can be taken on them.
class PersonnelRequestPolicyScopeTest < ActiveSupport::TestCase
  def setup
  end

  def teardown
  end

  test 'personnel requests have records' do
    # Without records, all the rest of the tests are probably meaningless
    assert LaborRequest.count > 0
    assert StaffRequest.count > 0
    assert ContractorRequest.count > 0
  end

  test 'user without role cannot see any personnel requests' do
    test_user = User.create(cas_directory_id: 'foobarbaz', name: 'Foo BarBaz')
    assert_equal 0, Pundit.policy_scope!(test_user, LaborRequest).count
    assert_equal 0, Pundit.policy_scope!(test_user, StaffRequest).count
    assert_equal 0, Pundit.policy_scope!(test_user, ContractorRequest).count
    test_user.destroy!
  end

  test 'admin role can see all personnel requests' do
    with_temp_user(admin: true) do |temp_user|
      assert_equal LaborRequest.count, Pundit.policy_scope!(temp_user, LaborRequest).count
      assert_equal StaffRequest.count, Pundit.policy_scope!(temp_user, StaffRequest).count
      assert_equal ContractorRequest.all.count, Pundit.policy_scope!(temp_user, ContractorRequest).count
    end
  end

  test 'division role can see all personnel requests' do
    expected_division_code = 'DSS'
    with_temp_user(divisions: [expected_division_code]) do |temp_user|
      assert_equal LaborRequest.count, Pundit.policy_scope!(temp_user, LaborRequest).count
      assert_equal StaffRequest.count, Pundit.policy_scope!(temp_user, StaffRequest).count
      assert_equal ContractorRequest.all.count, Pundit.policy_scope!(temp_user, ContractorRequest).count
    end
  end

  test 'department role can only see department personnel requests' do
    expected_department_code = departments_with_records[0].code
    with_temp_user(departments: [expected_department_code]) do |temp_user|
      labor_results = Pundit.policy_scope!(temp_user, LaborRequest)
      staff_results = Pundit.policy_scope!(temp_user, StaffRequest)
      contractor_results = Pundit.policy_scope!(temp_user, ContractorRequest)

      record_count = labor_results.count + staff_results.count + contractor_results.count
      assert record_count > 0, "No records found for department '#{expected_department_code}'"

      [labor_results, staff_results, contractor_results].each do |requests|
        requests.each do |r|
          assert_equal expected_department_code, r.department.code
        end
      end
    end
  end

  test 'unit role can only see unit personnel requests' do
    expected_unit_code = units_with_records[0].code
    with_temp_user(units: [expected_unit_code]) do |temp_user|
      labor_results = Pundit.policy_scope!(temp_user, LaborRequest)
      staff_results = Pundit.policy_scope!(temp_user, StaffRequest)
      contractor_results = Pundit.policy_scope!(temp_user, ContractorRequest)

      record_count = labor_results.count + staff_results.count + contractor_results.count
      assert record_count > 0, "No records found for unit '#{expected_unit_code}'"

      [labor_results, staff_results, contractor_results].each do |requests|
        requests.each do |r|
          assert_equal expected_unit_code, r.unit.code
        end
      end
    end
  end

  test 'multi-department user can only see personnel requests from those departments' do
    expected_department_code1 = departments_with_records[0].code
    expected_department_code2 = departments_with_records[1].code
    with_temp_user(departments: [expected_department_code1, expected_department_code2]) do |temp_user|
      labor_results = Pundit.policy_scope!(temp_user, LaborRequest)
      staff_results = Pundit.policy_scope!(temp_user, StaffRequest)
      contractor_results = Pundit.policy_scope!(temp_user, ContractorRequest)

      [labor_results, staff_results, contractor_results].each do |requests|
        requests.each do |r|
          assert_includes [expected_department_code1, expected_department_code2],
                          r.department.code
        end
      end
    end
  end

  test 'mixed department and unit user can only see personnel requests from that department or unit' do
    expected_department_code = departments_with_records[0].code
    expected_unit_code = units_with_records[0].code
    with_temp_user(departments: [expected_department_code], units: [expected_unit_code]) do |temp_user|
      labor_results = Pundit.policy_scope!(temp_user, LaborRequest)
      staff_results = Pundit.policy_scope!(temp_user, StaffRequest)
      contractor_results = Pundit.policy_scope!(temp_user, ContractorRequest)

      [labor_results, staff_results, contractor_results].each do |requests|
        requests.each do |r|
          if r.unit.nil?
            assert_equal expected_department_code, r.department.code
          else
            assert_equal expected_unit_code, r.unit.code
          end
        end
      end
    end
  end
end
