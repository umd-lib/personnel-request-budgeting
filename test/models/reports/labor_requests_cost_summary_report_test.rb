require 'test_helper'

# Tests Labor Requests Cost Summary report
class LaborRequestsCostSummaryReportTest < ActiveSupport::TestCase
  def setup
    @report = LaborRequestsCostSummaryReport.new
  end

  test 'should give a descriptions of itself' do
    assert_not @report.class.description.empty?
  end

  test 'should return an array containing a Hash and a Array of Hashes' do
    query_result = @report.query
    headers = query_result[0]
    data = query_result[1]

    assert headers.is_a?(Hash)
    assert data.is_a?(Array)

    # "data" should contain an entry for each division
    assert data.count == Division.count
  end
end
