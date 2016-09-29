require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  def test_suppress_status
    assert_equal '', suppress_status('Under Review')
    assert_equal 'Hot', suppress_status('Hot')
  end
end
