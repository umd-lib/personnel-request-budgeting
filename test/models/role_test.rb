require 'test_helper'

# Tests for the "Role" model
class RoleTest < ActiveSupport::TestCase
  def setup
    @role = roles(:one)
  end

  test 'should be valid' do
    assert @role.valid?
  end

  test 'user should be present' do
    @role.user = nil
    assert_not @role.valid?
  end

  test 'role type should be present' do
    @role.role_type = nil
    assert_not @role.valid?
  end

  test 'should require division if role type is division' do
    @role.role_type = role_types(:division)
    assert_not @role.valid?
    @role.division = divisions(:one)
    assert @role.valid?
  end

  test 'should require department if role type is department' do
    @role.role_type = role_types(:department)
    assert_not @role.valid?
    @role.department = departments(:one)
    assert @role.valid?
  end

  test 'should require unit if role type is unit' do
    @role.role_type = role_types(:unit)
    assert_not @role.valid?
    @role.unit = units(:one)
    assert @role.valid?
  end

  test 'should not allow duplicate role' do
    duplicate_role = roles(:one_with_department).dup
    assert_not duplicate_role.valid?
  end

  test 'should not allow role with multiple organizations' do
    role = Role.new(user: users(:one),
                    role_type: role_types(:division),
                    division: divisions(:dss),
                    department: departments(:ssdr))
    assert_not role.valid?
  end

  test 'should not allow admin role with any organizations' do
    role = Role.new(user: users(:one),
                    role_type: role_types(:admin),
                    division: divisions(:dss))
    assert_not role.valid?
  end

  test 'verify "description" method for various roles' do
    test_cases = {
      test_admin_role: 'Test Admin User, Admin',
      two_with_division: 'User Two, Division, Public Services',
      one_with_department: 'User One, Department, Software Systems Development and Research',
      johnny_with_unit: 'Johnny Dosroles, Unit, Humanities & Social Services'
    }

    test_cases.each do |role, expected_description|
      assert_equal expected_description, roles(role).description
    end
  end
end
