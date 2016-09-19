require 'test_helper'

# Tests for the "User" model
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(cas_directory_id: 'sample_user', name: 'Sample User')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'cas_directory_id should be present' do
    @user.cas_directory_id = '  '
    assert_not @user.valid?
  end

  test 'cas_directory_id should be unique' do
    duplicate_user = @user.dup
    duplicate_user.cas_directory_id = @user.cas_directory_id.upcase
    @user.save!
    assert_not duplicate_user.valid?
  end

  test 'name should be present' do
    @user.name = '  '
    assert_not @user.valid?
  end

  test 'admin? should show correct admin status of user' do
    assert_not @user.admin?
    assert users(:test_admin).admin?
    assert_not users(:test_not_admin).admin?
  end

  test 'division? should show correct division status of user' do
    assert_not @user.division?
    assert_not users(:test_admin).division?

    division_user = User.new(cas_directory_id: 'division_user', name: 'Division User')
    Role.create!(user: division_user,
                 role_type: RoleType.find_by_code('division'),
                 division: Division.first)
    assert division_user.division?
  end

  test 'department? should show correct department status of user' do
    assert_not @user.department?
    assert_not users(:test_admin).department?

    department_user = User.new(cas_directory_id: 'department_user', name: 'Department User')
    Role.create!(user: department_user,
                 role_type: RoleType.find_by_code('department'),
                 department: Department.first)
    assert department_user.department?
  end

  test 'unit? should show correct unit status of user' do
    assert_not @user.unit?
    assert_not users(:test_admin).unit?

    unit_user = User.new(cas_directory_id: 'unit_user', name: 'Unit User')
    Role.create!(user: unit_user,
                 role_type: RoleType.find_by_code('unit'),
                 unit: Unit.first)
    assert unit_user.unit?
  end

  test 'roles should return roles for the user' do
    assert @user.roles.empty?

    assert_equal 1, users(:test_admin).roles.count
    assert_equal role_types(:admin), users(:test_admin).roles[0].role_type
  end

  test 'should be able to delete a user and its roles' do
    user_to_delete = User.create!(cas_directory_id: 'delete_me', name: 'nobody')
    role_to_delete = Role.create!(user: user_to_delete, role_type: role_types(:division),
                                  division: divisions(:dss)
                                 )
    assert User.exists? user_to_delete.id
    assert_equal 1, user_to_delete.roles.count
    assert Role.exists? role_to_delete.id

    user_to_delete.destroy
    assert_not User.exists? user_to_delete.id
    assert_not Role.exists? role_to_delete.id
  end
end
