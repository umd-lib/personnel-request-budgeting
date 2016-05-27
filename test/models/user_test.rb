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

  test 'admin? should correct admin status of user' do
    refute @user.admin?
    assert users(:test_admin).admin?
    refute users(:test_not_admin).admin?
  end

  test 'division? should correct division status of user' do
    refute @user.division?
    refute users(:test_admin).division?

    division_user = User.new(cas_directory_id: 'division_user', name: 'Division User')
    Role.create!(user: division_user,
                 role_type: RoleType.find_by_code('division'),
                 division: Division.all[0])
    assert division_user.division?
  end

  test 'roles should return roles for the user' do
    assert @user.roles.empty?

    assert_equal 1, users(:test_admin).roles.count
    assert_equal role_types(:admin), users(:test_admin).roles[0].role_type
  end

end
