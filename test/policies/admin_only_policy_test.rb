# frozen_string_literal: true

require 'test_helper'

# Tests for AdminOnlyPolicy class
class AdminOnlyPolicyTest < ActiveSupport::TestCase
  def setup
    @admin_user = users(:admin)
    @not_admin_user = users(:not_admin)
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
end
