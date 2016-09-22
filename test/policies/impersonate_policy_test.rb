require 'test_helper'

# Tests for ImpersonatePolicy class
#
# Need to use ImpersonatePolicy.new, instead of Pundit.policy! in the
# tests because there is no "Impersonate" model Pundit can use to find
# the correct policy.
class ImpersonatePolicyTest < ActiveSupport::TestCase
  def setup
    @impersonated_user = users(:test_not_admin)
  end

  def teardown
  end

  test 'verify that admins can impersonate' do
    with_temp_user(admin: true) do |temp_user|
      assert ImpersonatePolicy.new(temp_user, nil).index?
      assert ImpersonatePolicy.new(temp_user, @impersonated_user).create?
      assert ImpersonatePolicy.new(temp_user, @impersonated_user).destroy?
    end
  end

  test 'verify that non-admins cannot impersonate' do
    with_temp_user(divisions: ['CSS']) do |temp_user|
      assert_not ImpersonatePolicy.new(temp_user, nil).index?
      assert_not ImpersonatePolicy.new(temp_user, @impersonated_user).create?
      assert ImpersonatePolicy.new(temp_user, @impersonated_user).destroy?
    end
  end

  test 'verify that admins cannot impersonate themselves or other admins' do
    admin_user1 = create_user_with_roles('admin1', admin: true)
    admin_user2 = create_user_with_roles('admin2', admin: true)

    assert_not ImpersonatePolicy.new(admin_user1, admin_user1).create?
    assert_not ImpersonatePolicy.new(admin_user1, admin_user2).create?
    assert ImpersonatePolicy.new(admin_user1, @impersonated_user).create?
  end

  test 'a nil user cannot be impersonated' do
    admin_user1 = create_user_with_roles('admin1', admin: true)
    assert_not ImpersonatePolicy.new(admin_user1, nil).create?
  end
end
