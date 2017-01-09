require 'test_helper'

# Tests Labor Requests Cost Summary report
class LaborRequestsCostSummaryReportTest < ActiveSupport::TestCase
  def setup
    @report = LaborRequestsCostSummaryReport.new
  end

  test 'should give a descriptions of itself' do
    assert_not @report.class.description.empty?
  end

  test 'should return a Hash containing an Array and a String' do
    query_result = @report.query
    summary_data = query_result[:summary_data]
    current_fiscal_year = query_result[:current_fiscal_year]

    assert summary_data.is_a?(Array)
    assert current_fiscal_year.is_a?(String)

    # "data" should contain an entry for each department
    assert summary_data.count == Department.count
  end
end
