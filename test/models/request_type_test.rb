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

  test 'name should be present' do
    @request_type.name = '  '
    assert_not @request_type.valid?
  end
end
