require 'test_helper'

# Tests for the "User" model
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(cas_directory_id: 'TEST_USER', name: 'Test User')
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
end
