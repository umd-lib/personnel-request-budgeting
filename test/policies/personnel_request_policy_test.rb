require 'test_helper'

# Tests for PersonnelRequestPolicy class
class PersonnelRequestPolicyTest < ActiveSupport::TestCase
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def setup
    @division1 = divisions_with_records[0]
    @division2 = divisions_with_records[1]
    @dept_in_division_1 = departments_with_records.keep_if { |d| d.division == @division1 }[0]
    @dept_not_in_division_1 = departments_with_records.keep_if { |d| d.division != @division1 }[0]
    @dept1 = departments_with_records[0]
    @dept2 = departments_with_records[1]
    @unit1 = units_with_records[0]

    @division_role_cutoff = RoleCutoff.where(role_type: RoleType.find_by_code('division')).first
    @division_role_cutoff.cutoff_date = 1.day.from_now
    @division_role_cutoff.save!

    @dept_role_cutoff = RoleCutoff.where(role_type: RoleType.find_by_code('department')).first
    @dept_role_cutoff.cutoff_date = 1.day.from_now
    @dept_role_cutoff.save!

    @unit_role_cutoff = RoleCutoff.where(role_type: RoleType.find_by_code('unit')).first
    @unit_role_cutoff.cutoff_date = 1.day.from_now
    @unit_role_cutoff.save!
  end

  def teardown
  end

  test 'verify allowed_divisions returns correct divisions' do
    # Single division user
    with_temp_user(divisions: [@division1.code]) do |temp_user|
      divisions = PersonnelRequestPolicy.allowed_divisions(temp_user)
      assert_equal 1, divisions.count
      assert_equal @division1, divisions[0]
    end

    # Multiple division user
    with_temp_user(divisions: [@division1.code, @division2.code]) do |temp_user|
      divisions = PersonnelRequestPolicy.allowed_divisions(temp_user)
      assert_equal 2, divisions.count
      divisions.each do |division|
        assert((@division1 == division) || (@division2 == division))
      end
    end

    # Division and department user
    with_temp_user(divisions: [@division1.code], departments: [@dept_not_in_division_1.code]) do |temp_user|
      divisions = PersonnelRequestPolicy.allowed_divisions(temp_user)
      assert_equal 1, divisions.count
      assert_equal @division1, divisions[0]
    end
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
    with_temp_user(divisions: [@division1.code]) do |temp_user|
      departments = PersonnelRequestPolicy.allowed_departments(temp_user)
      assert_equal Department.where(division: @division1).count, departments.count
      departments.each do |department|
        assert_equal @division1, department.division
      end
    end

    # Single department user
    with_temp_user(departments: [@dept1.code]) do |temp_user|
      departments = PersonnelRequestPolicy.allowed_departments(temp_user)
      assert_equal 1, departments.count
      assert_equal @dept1, departments[0]
    end

    # Multiple department user
    with_temp_user(departments: [@dept1.code, @dept2.code]) do |temp_user|
      departments = PersonnelRequestPolicy.allowed_departments(temp_user)
      assert_equal 2, departments.count
      departments.each do |department|
        assert((@dept1 == department) || (@dept2 == department))
      end
    end

    # Division and department user
    with_temp_user(divisions: [@division1.code], departments: [@dept_not_in_division_1.code]) do |temp_user|
      departments = PersonnelRequestPolicy.allowed_departments(temp_user)
      assert_equal (Department.where(division: @division1).count + 1), departments.count
      departments.each do |department|
        assert((@division1 == department.division) || (@dept_not_in_division_1 == department))
      end
    end
  end

  test 'verify allowed_units returns correct units' do
    # Single Unit user
    unit1 = units_with_records[0]
    with_temp_user(units: [unit1.code]) do |temp_user|
      units = PersonnelRequestPolicy.allowed_units(temp_user)
      assert_equal 1, units.count
      assert_equal unit1, units[0]
    end
  end

  test 'admin user can "show" all personnel requests' do
    labor_requests_all = LaborRequest.all

    with_temp_user(admin: true) do |temp_user|
      labor_requests_all.each do |r|
        assert Pundit.policy!(temp_user, r).show?,
               "Admin user could not 'show' " \
               "Labor Request id: #{r.id}, department: #{r.department.code}"
      end
    end
  end

  test 'division user can "show" all personnel requests' do
    labor_requests_all = LaborRequest.all

    with_temp_user(divisions: [@division1.code]) do |temp_user|
      labor_requests_all.each do |r|
        assert Pundit.policy!(temp_user, r).show?,
               "Division user could not 'show' " \
               "Labor Request id: #{r.id}, department: #{r.department.code}"
      end
    end
  end

  test 'department user can only "show" personnel requests in department' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(departments: [@dept1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).show?
          allow_count += 1
          assert_equal @dept1, r.department,
                       "User (dept=#{@dept1.code}) could 'show' " \
                       "Labor Request id: #{r.id}, dept: #{r.department.code}"
        else
          disallow_count += 1
          assert_not_equal @dept1, r.department,
                           "User (dept=#{@dept1.code}) could not 'show' " \
                           "Labor Request id: #{r.id}, dept: #{r.department.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed departments were tested!'
    assert disallow_count > 0, 'No disallowed departments were tested!'
  end

  test 'unit user can only "show" personnel requests in unit' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(units: [@unit1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).show?
          allow_count += 1
          assert_equal @unit1, r.unit,
                       "User (unit=#{@unit1.code}) could 'show' " \
                       "Labor Request id: #{r.id}, unit: #{r.unit.code}"
        else
          disallow_count += 1
          assert_not_equal @unit1, r.unit,
                           "User (unit=#{@unit1.code}) could not 'show' " \
                           "Labor Request id: #{r.id}, unit: #{r.unit.nil? ? nil : r.unit.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed units were tested!'
    assert disallow_count > 0, 'No disallowed units were tested!'
  end

  test 'admin user can "create" all personnel requests' do
    labor_requests_all = LaborRequest.all

    with_temp_user(admin: true) do |temp_user|
      labor_requests_all.each do |r|
        assert Pundit.policy!(temp_user, r).create?,
               "Admin user could not 'create' " \
               "Labor Request id: #{r.id}, department: #{r.department.code}"
      end
    end
  end

  test 'division user can only "create" personnel requests in division' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(divisions: [@division1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).create?
          allow_count += 1
          assert_equal @division1, r.department.division,
                       "User (div=#{@division1.code}) could 'create' " \
                       "Labor Request #{r.id}, div: #{r.department.division.code}"
        else
          disallow_count += 1
          assert_not_equal @division1, r.department.division,
                           "User (div=#{@division1.code}) could not 'create' " \
                           "Labor Request #{r.id}, div: #{r.department.division.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed divisions were tested!'
    assert disallow_count > 0, 'No disallowed divisions were tested!'
  end

  test 'department user can only "create" personnel requests in department' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(departments: [@dept1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).create?
          allow_count += 1
          assert_equal @dept1, r.department,
                       "User (dept=#{@dept1.code}) could 'create' " \
                       "Labor Request id: #{r.id}, dept: #{r.department.code}"
        else
          disallow_count += 1
          assert_not_equal @dept1, r.department,
                           "User (dept=#{@dept1.code}) could not 'create' " \
                           "Labor Request id: #{r.id}, dept: #{r.department.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed departments were tested!'
    assert disallow_count > 0, 'No disallowed departments were tested!'
  end

  test 'unit user can only "create" personnel requests in unit' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(units: [@unit1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).create?
          allow_count += 1
          assert_equal @unit1, r.unit,
                       "User (unit=#{@unit1.code}) could 'create' " \
                       "Labor Request id: #{r.id}, unit: #{r.unit.code}"
        else
          disallow_count += 1
          assert_not_equal @unit1, r.unit,
                           "User (unit=#{@unit1.code}) could not 'create' " \
                           "Labor Request id: #{r.id}, unit: #{r.unit.nil? ? nil : r.unit.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed units were tested!'
    assert disallow_count > 0, 'No disallowed units were tested!'
  end

  test 'admin user can "update" all personnel requests' do
    labor_requests_all = LaborRequest.all

    with_temp_user(admin: true) do |temp_user|
      labor_requests_all.each do |r|
        assert Pundit.policy!(temp_user, r).update?,
               "Admin user could not 'update' Labor Request id: #{r.id}, department: #{r.department.code}"
      end
    end
  end

  test 'division user can only "update" personnel requests in division' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(divisions: [@division1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).update?
          allow_count += 1
          assert_equal @division1, r.department.division,
                       "User (div=#{@division1.code}) could 'update' " \
                       "Labor Request #{r.id}, div: #{r.department.division.code}"
        else
          disallow_count += 1
          assert_not_equal @division1, r.department.division,
                           "User (div=#{@division1.code}) could not 'update' " \
                           "Labor Request #{r.id}, div: #{r.department.division.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed divisions were tested!'
    assert disallow_count > 0, 'No disallowed divisions were tested!'
  end

  test 'department user can only "update" personnel requests in department' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(departments: [@dept1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).update?
          allow_count += 1
          assert_equal @dept1, r.department,
                       "User (dept=#{@dept1.code}) could 'update' " \
                       "Labor Request id: #{r.id}, dept: #{r.department.code}"
        else
          disallow_count += 1
          assert_not_equal @dept1, r.department,
                           "User (dept=#{@dept1.code}) could not 'update' " \
                           "Labor Request id: #{r.id}, dept: #{r.department.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed departments were tested!'
    assert disallow_count > 0, 'No disallowed departments were tested!'
  end

  test 'unit user can only "update" personnel requests in unit' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0
    with_temp_user(units: [@unit1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).update?
          allow_count += 1
          assert_equal @unit1, r.unit,
                       "User (unit=#{@unit1.code}) could 'update' " \
                       "Labor Request id: #{r.id}, unit: #{r.unit.code}"
        else
          disallow_count += 1
          assert_not_equal @unit1, r.unit,
                           "User (unit=#{@unit1.code}) could not 'update' " \
                           "Labor Request id: #{r.id}, unit: #{r.unit.nil? ? nil : r.unit.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed units were tested!'
    assert disallow_count > 0, 'No disallowed units were tested!'
  end

  test 'admin user can "destroy" all personnel requests' do
    labor_requests_all = LaborRequest.all

    with_temp_user(admin: true) do |temp_user|
      labor_requests_all.each do |r|
        assert Pundit.policy!(temp_user, r).destroy?,
               "Admin user could not 'destroy' Labor Request id: #{r.id}, department: #{r.department.code}"
      end
    end
  end

  test 'division user can only "destroy" personnel requests in division' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(divisions: [@division1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).destroy?
          allow_count += 1
          assert_equal @division1, r.department.division,
                       "User (div=#{@division1.code}) could 'destroy' " \
                       "Labor Request #{r.id}, div: #{r.department.division.code}"
        else
          disallow_count += 1
          assert_not_equal @division1, r.department.division,
                           "User (div=#{@division1.code}) could not 'destroy' " \
                           "Labor Request #{r.id}, div: #{r.department.division.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed divisions were tested!'
    assert disallow_count > 0, 'No disallowed divisions were tested!'
  end

  test 'department user can only "destroy" personnel requests in department' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0

    with_temp_user(departments: [@dept1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).destroy?
          allow_count += 1
          assert_equal @dept1, r.department,
                       "User (dept=#{@dept1.code}) could 'destroy' " \
                       "Labor Request id: #{r.id}, dept: #{r.department.code}"
        else
          disallow_count += 1
          assert_not_equal @dept1, r.department,
                           "User (dept=#{@dept1.code}) could not 'destroy' " \
                           "Labor Request id: #{r.id}, dept: #{r.department.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed departments were tested!'
    assert disallow_count > 0, 'No disallowed departments were tested!'
  end

  test 'unit user can only "destroy" personnel requests in unit' do
    labor_requests_all = LaborRequest.all

    allow_count = 0
    disallow_count = 0
    with_temp_user(units: [@unit1.code]) do |temp_user|
      labor_requests_all.each do |r|
        if Pundit.policy!(temp_user, r).destroy?
          allow_count += 1
          assert_equal @unit1, r.unit,
                       "User (unit=#{@unit1.code}) could 'destroy' " \
                       "Labor Request id: #{r.id}, unit: #{r.unit.code}"
        else
          disallow_count += 1
          assert_not_equal @unit1, r.unit,
                           "User (unit=#{@unit1.code}) could not 'destroy' " \
                           "Labor Request id: #{r.id}, unit: #{r.unit.nil? ? nil : r.unit.code}"
        end
      end
    end

    assert allow_count > 0, 'No allowed units were tested!'
    assert disallow_count > 0, 'No disallowed units were tested!'
  end

  test 'user with any roles should be able to "new" personnel requests' do
    with_temp_user(departments: [@dept1.code]) do |temp_user|
      assert Pundit.policy!(temp_user, LaborRequest).new?
    end
  end

  test 'user without roles should not be able to "new" personnel requests' do
    no_role_user = User.create(cas_directory_id: 'no_role', name: 'No Role')
    refute Pundit.policy!(no_role_user, LaborRequest).new?
    no_role_user.destroy!
  end

  test 'user cannot create "new" personnel when role is past cutoff' do
    with_temp_user(units: [@unit1.code]) do |temp_user|
      assert Pundit.policy!(temp_user, LaborRequest).new?
      @unit_role_cutoff.cutoff_date = 1.day.ago
      @unit_role_cutoff.save!
      refute Pundit.policy!(temp_user, LaborRequest).new?
    end

    with_temp_user(departments: [@dept1.code]) do |temp_user|
      assert Pundit.policy!(temp_user, LaborRequest).new?
      @dept_role_cutoff.cutoff_date = 1.day.ago
      @dept_role_cutoff.save!
      refute Pundit.policy!(temp_user, LaborRequest).new?
    end

    with_temp_user(divisions: [@division1.code]) do |temp_user|
      assert Pundit.policy!(temp_user, LaborRequest).new?
      @division_role_cutoff.cutoff_date = 1.day.ago
      @division_role_cutoff.save!
      refute Pundit.policy!(temp_user, LaborRequest).new?
    end
  end

  test 'verify unit edit permissions with role cutoff' do
    with_temp_user(units: [@unit1.code]) do |temp_user|
      request = LaborRequest.where(unit_id: @unit1).first
      assert Pundit.policy!(temp_user, request).show?

      assert Pundit.policy!(temp_user, request).create?
      assert Pundit.policy!(temp_user, request).update?
      assert Pundit.policy!(temp_user, request).destroy?

      @unit_role_cutoff.cutoff_date = 1.day.ago
      @unit_role_cutoff.save!

      # Still allowed to view after cutoff
      assert Pundit.policy!(temp_user, request).show?

      refute Pundit.policy!(temp_user, request).create?
      refute Pundit.policy!(temp_user, request).update?
      refute Pundit.policy!(temp_user, request).destroy?
    end
  end

  test 'verify department edit permissions with role cutoff' do
    with_temp_user(departments: [@dept1.code]) do |temp_user|
      request = LaborRequest.where(department_id: @dept1).first
      assert Pundit.policy!(temp_user, request).show?

      assert Pundit.policy!(temp_user, request).create?
      assert Pundit.policy!(temp_user, request).update?
      assert Pundit.policy!(temp_user, request).destroy?

      @dept_role_cutoff.cutoff_date = 1.day.ago
      @dept_role_cutoff.save!

      # Still allowed to view after cutoff
      assert Pundit.policy!(temp_user, request).show?

      refute Pundit.policy!(temp_user, request).create?
      refute Pundit.policy!(temp_user, request).update?
      refute Pundit.policy!(temp_user, request).destroy?
    end
  end

  test 'verify division edit permissions with role cutoff' do
    with_temp_user(divisions: [@division1.code]) do |temp_user|
      request = LaborRequest.where(department_id: @dept_in_division_1).first
      assert Pundit.policy!(temp_user, request).show?

      assert Pundit.policy!(temp_user, request).create?
      assert Pundit.policy!(temp_user, request).update?
      assert Pundit.policy!(temp_user, request).destroy?

      @division_role_cutoff.cutoff_date = 1.day.ago
      @division_role_cutoff.save!

      # Still allowed to view after cutoff
      assert Pundit.policy!(temp_user, request).show?

      refute Pundit.policy!(temp_user, request).create?
      refute Pundit.policy!(temp_user, request).update?
      refute Pundit.policy!(temp_user, request).destroy?
    end
  end

  test 'verify selectable_units' do
    with_temp_user(admin: true) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal Unit.all, policy.selectable_units(temp_user)
    end

    # Single unit user
    with_temp_user(units: ['LN']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal ['LN'], policy.selectable_units(temp_user).map(&:code).sort
    end

    # Multi-unit user
    with_temp_user(units: %w(LN TLC)) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = %w(LN TLC)
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end

    # Single department user (no units in department)
    with_temp_user(departments: ['SSDR']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal [], policy.selectable_units(temp_user)
    end

    # Single department user (department has units)
    with_temp_user(departments: ['AS']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = %w(ILL LN LSD STK TLC)
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end

    # User with department and unit (not in department)
    with_temp_user(departments: ['AS'], units: ['TL']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = %w(ILL LN LSD STK TL TLC)
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end

    # Division user (division has units)
    with_temp_user(divisions: ['PSD']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = %w(ARCH ART CHEM EPSL HSSL ILL LN LSD MSPAL RC RL STK TL TLC)
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end
  end

  test 'verify selectable_units with role cutoff' do
    @unit_role_cutoff.cutoff_date = 1.day.ago
    @unit_role_cutoff.save!

    with_temp_user(admin: true) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal Unit.all, policy.selectable_units(temp_user)
    end

    # Single unit user
    with_temp_user(units: ['LN']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal [], policy.selectable_units(temp_user).map(&:code).sort
    end

    # Multi-unit user
    with_temp_user(units: %w(LN TLC)) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = []
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end

    # Single department user (no units in department)
    with_temp_user(departments: ['SSDR']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal [], policy.selectable_units(temp_user)
    end

    # Single department user (department has units)
    with_temp_user(departments: ['AS']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = %w(ILL LN LSD STK TLC)
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end

    # User with department and unit (not in department)
    with_temp_user(departments: ['AS'], units: ['TL']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = %w(ILL LN LSD STK TLC) # Should not include TL
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end

    # Division user (division has units)
    with_temp_user(divisions: ['PSD']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = %w(ARCH ART CHEM EPSL HSSL ILL LN LSD MSPAL RC RL STK TL TLC)
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end

    @division_role_cutoff.cutoff_date = 1.day.ago
    @division_role_cutoff.save!
    # Division user (division has units)
    with_temp_user(divisions: ['PSD']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_units = []
      assert_equal expected_units, policy.selectable_units(temp_user).map(&:code).sort
    end
  end

  test 'verify selectable_departments' do
    with_temp_user(admin: true) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal Department.all, policy.selectable_departments(temp_user)
    end

    # Single unit user
    with_temp_user(units: ['LN']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal ['AS'], policy.selectable_departments(temp_user).map(&:code).sort
    end

    # Multi-unit user
    with_temp_user(units: %w(CHEM LN)) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_departments = %w(AS RL)
      assert_equal expected_departments, policy.selectable_departments(temp_user).map(&:code).sort
    end

    # Single department user (no units in department)
    with_temp_user(departments: ['SSDR']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal ['SSDR'], policy.selectable_departments(temp_user).map(&:code).sort
    end

    # Single department user (department has units)
    with_temp_user(departments: ['AS']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal ['AS'], policy.selectable_departments(temp_user).map(&:code).sort
    end

    # User with department and unit (not in department)
    with_temp_user(departments: ['AS'], units: ['TL']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_departments = %w(AS RL)
      assert_equal expected_departments, policy.selectable_departments(temp_user).map(&:code).sort
    end

    # Division user (division has units)
    with_temp_user(divisions: ['PSD']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_departments = %w(AS LMS PS RL)
      assert_equal expected_departments, policy.selectable_departments(temp_user).map(&:code).sort
    end
  end

  test 'verify selectable_departments with role cutoff' do
    @dept_role_cutoff.cutoff_date = 1.day.ago
    @dept_role_cutoff.save!

    with_temp_user(admin: true) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal Department.all, policy.selectable_departments(temp_user)
    end

    # Single unit user
    with_temp_user(units: ['LN']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal ['AS'], policy.selectable_departments(temp_user).map(&:code).sort
    end

    # Multi-unit user
    with_temp_user(units: %w(CHEM LN)) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_departments = %w(AS RL)
      assert_equal expected_departments, policy.selectable_departments(temp_user).map(&:code).sort
    end

    # Single department user (no units in department)
    with_temp_user(departments: ['SSDR']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal [], policy.selectable_departments(temp_user).map(&:code).sort
    end

    # Single department user (department has units)
    with_temp_user(departments: ['AS']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      assert_equal [], policy.selectable_departments(temp_user).map(&:code).sort
    end

    # User with department and unit (not in department)
    with_temp_user(departments: ['AS'], units: ['TL']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_departments = %w(RL) # RL allowed because of unit role
      assert_equal expected_departments, policy.selectable_departments(temp_user).map(&:code).sort
    end

    # Division user (division has units)
    with_temp_user(divisions: ['PSD']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_departments = %w(AS LMS PS RL)
      assert_equal expected_departments, policy.selectable_departments(temp_user).map(&:code).sort
    end

    @division_role_cutoff.cutoff_date = 1.day.ago
    @division_role_cutoff.save!
    # Division user (division has units)
    with_temp_user(divisions: ['PSD']) do |temp_user|
      policy = Pundit.policy!(temp_user, LaborRequest.new)
      expected_departments = []
      assert_equal expected_departments, policy.selectable_departments(temp_user).map(&:code).sort
    end
  end
end
