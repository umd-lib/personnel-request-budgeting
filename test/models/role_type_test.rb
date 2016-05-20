require 'test_helper'

# Tests for the "RoleType" model
class RoleTypeTest < ActiveSupport::TestCase
  def setup
    @role_type = role_types(:one)
  end

  test 'should be valid' do
    assert @role_type.valid?
  end

  test 'code should be present' do
    @role_type.code = '  '
    assert_not @role_type.valid?
  end

  test 'code should be unique' do
    duplicate_role_type = @role_type.dup
    duplicate_role_type.code = @role_type.code.upcase
    @role_type.save!
    assert_not duplicate_role_type.valid?
  end

  test 'name should be present' do
    @role_type.name = '  '
    assert_not @role_type.valid?
  end

  test 'role type without associated records can be deleted' do
    assert_equal true, @role_type.allow_delete?
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      @role_type.destroy
    end
  end

  test 'role type with associated records cannot be deleted' do
    role_type = role_types(:admin)
    assert_equal false, role_type.allow_delete?
    assert_raise ActiveRecord::DeleteRestrictionError do
      role_type.destroy
    end
  end
end
