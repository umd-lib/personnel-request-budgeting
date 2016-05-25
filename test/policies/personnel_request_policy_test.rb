require 'test_helper'

# Tests for PersonnelRequestPolicy's Scope class
# These tests only cover visibility of the personnel requests, not the
# actions that can be taken on them.
class PersonnelRequestPolicyScopeTest < ActiveSupport::TestCase
  def setup
    @test_user = User.create(cas_directory_id: 'foobarbaz', name: 'Foo BarBaz')
  end

  test 'personnel requests have records' do
    # Without records, all the rest of the tests are probably meaningless
    assert LaborRequest.count > 0
    assert StaffRequest.count > 0
    assert ContractorRequest.count > 0
  end

  test 'user without role cannot see any personnel requests' do
    assert_equal 0, Pundit.policy_scope!(@test_user, LaborRequest).count
    assert_equal 0, Pundit.policy_scope!(@test_user, StaffRequest).count
    assert_equal 0, Pundit.policy_scope!(@test_user, ContractorRequest).count
  end

  test 'admin role can see all personnel requests' do
    Role.create!(user: @test_user, role_type: RoleType.find_by_code('admin'))

    assert_equal LaborRequest.count, Pundit.policy_scope!(@test_user, LaborRequest).count
    assert_equal StaffRequest.count, Pundit.policy_scope!(@test_user, StaffRequest).count
    assert_equal ContractorRequest.all.count, Pundit.policy_scope!(@test_user, ContractorRequest).count
  end

  test 'division role can see all personnel requests' do
    expected_division_code = 'DSS'
    Role.create!(user: @test_user,
                 role_type: RoleType.find_by_code('division'),
                 division: Division.find_by_code(expected_division_code))

    assert_equal LaborRequest.count, Pundit.policy_scope!(@test_user, LaborRequest).count
    assert_equal StaffRequest.count, Pundit.policy_scope!(@test_user, StaffRequest).count
    assert_equal ContractorRequest.all.count, Pundit.policy_scope!(@test_user, ContractorRequest).count
  end

  test 'department role can only see department personnel requests' do
    expected_department_code = department_codes_with_records[0]
    Role.create!(user: @test_user,
                 role_type: RoleType.find_by_code('department'),
                 department: Department.find_by_code(expected_department_code))

    labor_results = Pundit.policy_scope!(@test_user, LaborRequest)
    staff_results = Pundit.policy_scope!(@test_user, StaffRequest)
    contractor_results = Pundit.policy_scope!(@test_user, ContractorRequest)

    record_count = labor_results.count + staff_results.count + contractor_results.count
    assert record_count > 0, "No records found for department '#{expected_department_code}'"

    [labor_results, staff_results, contractor_results].each do |requests|
      requests.each do |r|
        assert_equal expected_department_code, r.department.code
      end
    end
  end

  test 'unit role can only see unit personnel requests' do
    expected_unit_code = unit_codes_with_records[0]
    Role.create!(user: @test_user,
                 role_type: RoleType.find_by_code('unit'),
                 unit: Unit.find_by_code(expected_unit_code))

    labor_results = Pundit.policy_scope!(@test_user, LaborRequest)
    staff_results = Pundit.policy_scope!(@test_user, StaffRequest)
    contractor_results = Pundit.policy_scope!(@test_user, ContractorRequest)

    record_count = labor_results.count + staff_results.count + contractor_results.count
    assert record_count > 0, "No records found for unit '#{expected_unit_code}'"

    [labor_results, staff_results, contractor_results].each do |requests|
      requests.each do |r|
        assert_equal expected_unit_code, r.unit.code
      end
    end
  end

  test 'multi-department user can only see personnel requests from those departments' do
    expected_department_code1 = department_codes_with_records[0]
    expected_department_code2 = department_codes_with_records[1]
    Role.create!(user: @test_user,
                 role_type: RoleType.find_by_code('department'),
                 department: Department.find_by_code(expected_department_code1))
    Role.create!(user: @test_user,
                 role_type: RoleType.find_by_code('department'),
                 department: Department.find_by_code(expected_department_code2))

    labor_results = Pundit.policy_scope!(@test_user, LaborRequest)
    staff_results = Pundit.policy_scope!(@test_user, StaffRequest)
    contractor_results = Pundit.policy_scope!(@test_user, ContractorRequest)

    [labor_results, staff_results, contractor_results].each do |requests|
      requests.each do |r|
        assert_includes [expected_department_code1, expected_department_code2],
                        r.department.code
      end
    end
  end

  test 'mixed department and unit user can only see personnel requests from that department or unit' do
    expected_department_code = department_codes_with_records[0]
    expected_unit_code = unit_codes_with_records[0]
    Role.create!(user: @test_user,
                 role_type: RoleType.find_by_code('department'),
                 department: Department.find_by_code(expected_department_code))
    Role.create!(user: @test_user,
                 role_type: RoleType.find_by_code('unit'),
                 unit: Unit.find_by_code(expected_unit_code))

    labor_results = Pundit.policy_scope!(@test_user, LaborRequest)
    staff_results = Pundit.policy_scope!(@test_user, StaffRequest)
    contractor_results = Pundit.policy_scope!(@test_user, ContractorRequest)

    [labor_results, staff_results, contractor_results].each do |requests|
      requests.each do |r|
        if ( r.unit.nil? )
          assert_equal expected_department_code, r.department.code
        else
          assert_equal expected_unit_code, r.unit.code
        end
      end
    end
  end

  def teardown
    Role.destroy_all(user: @test_user)
    @test_user.destroy!
  end

  private

    # Returns an array of department codes that have at least one record
    def department_codes_with_records
      LaborRequest.select(:department_id).distinct.collect { |r| r.department.code }
    end

    # Returns an array of unit codes that have at least one record
    def unit_codes_with_records
      LaborRequest.select(:unit_id).distinct.collect { |r| r.unit.code unless r.unit.nil? }.compact
    end
end
