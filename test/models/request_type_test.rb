require 'test_helper'

# Tests for the "RequestType" model
class RequestTypeTest < ActiveSupport::TestCase
  def setup
    @request_type = request_types(:one)
  end

  test 'should be valid' do
    assert @request_type.valid?
  end

  test 'code should be present' do
    @request_type.code = '  '
    assert_not @request_type.valid?
  end

  test 'code should be unique' do
    duplicate_request_type = @request_type.dup
    duplicate_request_type.code = @request_type.code.upcase
    @request_type.save!
    assert_not duplicate_request_type.valid?
  end

  test 'name should be present' do
    @request_type.name = '  '
    assert_not @request_type.valid?
  end

  test 'request type without associated records can be deleted' do
    assert_equal true, @request_type.allow_delete?
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      @request_type.destroy
    end
  end

  test 'request type with associated records cannot be deleted' do
    request_type = request_types(:new)
    assert_equal false, request_type.allow_delete?
    assert_raise ActiveRecord::DeleteRestrictionError do
      request_type.destroy
    end
  end
end
