require 'test_helper'

# Tests for PersonnelRequestPolicy class
class PersonnelRequestPolicyTest < ActiveSupport::TestCase
  def setup
    @admin_user = users(:test_admin)
    @division1 = divisions_with_records[0]
    @division2 = divisions_with_records[1]
    @dept_not_in_division_1 = departments_with_records.keep_if { |d| d.division != @division1 }[0]
    @dept1 = departments_with_records[0]
    @dept2 = departments_with_records[1]
    @unit1 = units_with_records[0]

    @division1_user = User.create(cas_directory_id: 'division1', name: 'Division1 User')
    Role.create!(user: @division1_user,
                 role_type: RoleType.find_by_code('division'),
                 division: @division1)

    @dept1_user = User.create(cas_directory_id: 'dept1', name: 'Dept1 User')
    Role.create!(user: @dept1_user,
                 role_type: RoleType.find_by_code('department'),
                 department: @dept1)

    @unit1_user = User.create(cas_directory_id: 'unit1', name: 'Unit1 User')
    Role.create!(user: @unit1_user,
                 role_type: RoleType.find_by_code('unit'),
                 unit: @unit1)
  end

  test 'verify departments_in_division returns correct departments' do
    departments = PersonnelRequestPolicy.departments_in_division(@division1)
    assert departments.count > 0
    departments.each do |d|
      assert d.division == @division1
    end
  end

  test 'verify allowed_departments returns correct departments' do
    # Division user
    departments = PersonnelRequestPolicy.allowed_departments(@division1_user)
    assert_equal Department.where(division: @division1).count, departments.count
    departments.each do |department|
      assert_equal @division1, department.division
    end

    # Single department user
    departments = PersonnelRequestPolicy.allowed_departments(@dept1_user)
    assert_equal 1, departments.count
    assert_equal @dept1, departments[0]

    # Multiple department user
    multi_dept_user = User.create(cas_directory_id: 'multi_dept', name: 'Multi Department')
    Role.create!(user: multi_dept_user,
                 role_type: RoleType.find_by_code('department'),
                 department: @dept1)
    Role.create!(user: multi_dept_user,
                 role_type: RoleType.find_by_code('department'),
                 department: @dept2)
    departments = PersonnelRequestPolicy.allowed_departments(multi_dept_user)
    assert_equal 2, departments.count
    departments.each do |department|
      assert((@dept1 == department) || (@dept2 == department))
    end
    Role.destroy_all(user: multi_dept_user)
    multi_dept_user.destroy!

    # Division and department user
    multi_div_dept_user = User.create(cas_directory_id: 'multi_div_dept', name: 'Multi Div-Department')
    Role.create!(user: multi_div_dept_user,
                 role_type: RoleType.find_by_code('division'),
                 division: @division1)
    Role.create!(user: multi_div_dept_user,
                 role_type: RoleType.find_by_code('department'),
                 department: @dept_not_in_division_1)
    departments = PersonnelRequestPolicy.allowed_departments(multi_div_dept_user)
    assert_equal (Department.where(division: @division1).count + 1), departments.count
    departments.each do |department|
      assert((@division1 == department.division) || (@dept_not_in_division_1 == department))
    end
    Role.destroy_all(user: multi_div_dept_user)
    multi_div_dept_user.destroy!
  end

  test 'verify allowed_units returns correct units' do
    # Single Unit user
    unit1 = units_with_records[0]
    unit1_user = User.create(cas_directory_id: 'unit', name: 'Unit User')
    Role.create!(user: unit1_user,
                 role_type: RoleType.find_by_code('unit'),
                 unit: unit1)
    units = PersonnelRequestPolicy.allowed_units(unit1_user)
    assert_equal 1, units.count
    assert_equal unit1, units[0]
    Role.destroy_all(user: unit1_user)
    unit1_user.destroy!
  end

  test 'admin user can "show" all personnel requests' do
    labor_requests_all = LaborRequest.all

    labor_requests_all.each do |r|
      assert Pundit.policy!(@admin_user, r).show?,
             "Admin user could not 'show' Labor Request id: #{r.id}, department: #{r.department.code}"
    end
  end

  test 'division user can "show" all personnel requests' do
    labor_requests_all = LaborRequest.all

    labor_requests_all.each do |r|
      assert Pundit.policy!(@division1_user, r).show?,
             "Division user could not 'show' Labor Request id: #{r.id}, department: #{r.department.code}"
    end
  end

  test 'department user can only "show" personnel requests in department' do
    labor_requests_all = LaborRequest.all
    allowed_departments = PersonnelRequestPolicy.allowed_departments(@dept1_user)

    allow_count = 0
    disallow_count = 0
    labor_requests_all.each do |r|
      if allowed_departments.include?(r.department)
        assert Pundit.policy!(@dept1_user, r).show?,
               "User (dept=#{@dept1.code}) could not 'show' Labor Request id: #{r.id}, dept: #{r.department.code}"
        allow_count += 1
      else
        refute Pundit.policy!(@dept1_user, r).show?,
               "User (dept=#{@dept1.code}) could 'show' Labor Request id: #{r.id}, dept: #{r.department.code}"
        disallow_count += 1
      end
    end

    assert allow_count > 0, 'No allowed departments were tested!'
    assert disallow_count > 0, 'No disallowed departments were tested!'
  end

  test 'unit user can "show" personnel requests in unit' do
    labor_requests_all = LaborRequest.all
    allowed_units = PersonnelRequestPolicy.allowed_units(@unit1_user)

    allow_count = 0
    disallow_count = 0
    labor_requests_all.each do |r|
      if allowed_units.include?(r.unit)
        assert Pundit.policy!(@unit1_user, r).show?,
               "User (unit=#{@unit1.code}) could not 'show' Labor Request id: #{r.id}, unit: #{r.unit.code}"
        allow_count += 1
      else
        refute Pundit.policy!(@unit1_user, r).show?,
               "User (unit=#{@unit1.code}) could 'show' Labor Request id: #{r.id}, unit: " +
               (r.unit.nil? ? nil : r.unit.code).to_s
        disallow_count += 1
      end
    end

    assert allow_count > 0, 'No allowed units were tested!'
    assert disallow_count > 0, 'No disallowed units were tested!'
  end

  def teardown
    Role.destroy_all(user: @division1_user)
    @division1_user.destroy!

    Role.destroy_all(user: @dept1_user)
    @dept1_user.destroy!

    Role.destroy_all(user: @unit1_user)
    @unit1_user.destroy!
  end
end
