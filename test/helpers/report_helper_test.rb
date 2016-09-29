require 'test_helper'

class ReportsHelperTest < ActionView::TestCase
  include ReportsHelper

  def test_report_formats
    assert_equal %w( xlsx ), report_formats(RequestsByTypeReport.new)
  end
end
