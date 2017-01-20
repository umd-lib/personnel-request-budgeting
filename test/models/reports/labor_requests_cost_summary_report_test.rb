require 'test_helper'

# Tests Labor Requests Cost Summary report
class LaborRequestsCostSummaryReportTest < ActiveSupport::TestCase
  def setup
    @report = LaborRequestsCostSummaryReport.new

    # Set review status ids to include in the report
    review_status_ids = ReviewStatus.all.map { |rs| rs.id }
    @report.parameters = { review_status_ids: review_status_ids }
  end

  test 'should give a descriptions of itself' do
    assert_not @report.class.description.empty?
  end

  test 'should return a Hash containing various pieces of data' do
    query_result = @report.query
    summary_data = query_result[:summary_data]
    divisions = query_result[:divisions]
    current_fiscal_year = query_result[:current_fiscal_year]
    previous_fiscal_year = query_result[:previous_fiscal_year]
    allowed_review_statuses = query_result[:allowed_review_statuses]

    assert summary_data.is_a?(Array)
    assert_equal Division.count, divisions.count
    assert_equal I18n.t(:current_fiscal_year),  current_fiscal_year
    assert_equal I18n.t(:previous_fiscal_year),  previous_fiscal_year

    # "data" should contain an entry for each department
    assert summary_data.count == Department.count
  end
end
