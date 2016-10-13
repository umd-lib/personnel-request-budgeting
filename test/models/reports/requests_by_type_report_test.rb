require 'test_helper'

# Tests requests by type reports
class RequestsByTypeReportTest < ActiveSupport::TestCase
  def setup
    @report = RequestsByTypeReport.new
  end

  test 'should give a descriptions of itself' do
    assert_equal(@report.class.description, 'A basic report that collects all requests by type')
  end

  test 'should return an enumerable-like / iterable object with a query' do
    assert @report.query.respond_to? :each
  end
end
