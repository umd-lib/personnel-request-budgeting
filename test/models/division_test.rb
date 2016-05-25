require 'test_helper'

# Tests for the "Division" model
class DivisionTest < ActiveSupport::TestCase
  def setup
    @division = Division.new(code: 'TD', name: 'Test Division')
  end

  test 'should be valid' do
    assert @division.valid?
  end

  test 'code should be present' do
    @division.code = '  '
    assert_not @division.valid?
  end

  test 'code should be unique' do
    duplicate_division = @division.dup
    duplicate_division.code = @division.code.downcase
    @division.save!
    assert_not duplicate_division.valid?
  end

  test 'name should be present' do
    @division.name = '  '
    assert_not @division.valid?
  end

  test 'division without associated records can be deleted' do
    @division = Division.create(code: 'Delete', name: 'DeleteMe')
    assert_equal true, @division.allow_delete?
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      @division.destroy
    end
  end

  test 'division with associated records cannot be deleted' do
    @division = Division.create(code: 'NoDelete', name: 'DoNotDeleteMe')
    Department.create(code: 'Test', name: 'Test Department', division: @division)
    assert_equal false, @division.allow_delete?
    assert_raise ActiveRecord::DeleteRestrictionError do
      @division.destroy
    end
  end
end
