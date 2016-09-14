require 'test_helper'

# Tests for the "RoleCutoff" model
class RoleCutoffTest < ActiveSupport::TestCase
  def setup
    @role_cutoff = role_cutoffs(:one)
  end

  test 'should be valid' do
    assert @role_cutoff.valid?
  end

  test 'role_type should be present' do
    @role_cutoff.role_type = nil
    assert_not @role_cutoff.valid?
  end

  test 'role_type should be unique' do
    duplicate_role_cutoff = @role_cutoff.dup
    duplicate_role_cutoff.role_type = @role_cutoff.role_type
    @role_cutoff.save!
    assert_not duplicate_role_cutoff.valid?
  end

  test 'role_type should not be admin' do
    @role_cutoff.role_type = role_types(:admin)
    assert_not @role_cutoff.valid?
  end

  test 'cutoff_date should be present' do
    @role_cutoff.cutoff_date = '  '
    assert_not @role_cutoff.valid?
  end
end
