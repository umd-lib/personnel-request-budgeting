require 'test_helper'

# Tests for AdminOnlyPolicy class
class AdminOnlyPolicyTest < ActiveSupport::TestCase
  def setup
    @admin_user = users(:test_admin)
    @not_admin_user = User.create(cas_directory_id: 'foobarbaz', name: 'Foo BarBaz')
    Role.create!(user: @not_admin_user,
                 role_type: RoleType.find_by_code('department'),
                 department: Department.find_by_code('SSDR'))
  end

  # In the following the "Role" object is used to get the AdminOnlyPolicy
  def test_index
    assert Pundit.policy!(@admin_user, Role).index?
    refute Pundit.policy!(@not_admin_user, Role).index?
  end

  def test_show
    assert Pundit.policy!(@admin_user, Role).show?
    refute Pundit.policy!(@not_admin_user, Role).show?
  end

  def test_new
    assert Pundit.policy!(@admin_user, Role).new?
    refute Pundit.policy!(@not_admin_user, Role).new?
  end

  def test_edit
    assert Pundit.policy!(@admin_user, Role).edit?
    refute Pundit.policy!(@not_admin_user, Role).edit?
  end

  def test_create
    assert Pundit.policy!(@admin_user, Role).create?
    refute Pundit.policy!(@not_admin_user, Role).create?
  end

  def test_update
    assert Pundit.policy!(@admin_user, Role).update?
    refute Pundit.policy!(@not_admin_user, Role).update?
  end

  def test_destroy
    assert Pundit.policy!(@admin_user, Role).destroy?
    refute Pundit.policy!(@not_admin_user, Role).destroy?
  end

  def test_scope
  end

  def teardown
    Role.destroy_all(user: @not_admin_user)
    @not_admin_user.destroy!
  end
end
