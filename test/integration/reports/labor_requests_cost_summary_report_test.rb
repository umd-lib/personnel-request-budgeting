require 'test_helper'
require 'minitest/hooks/test'

# Integration test for various parts of the reports workflow
class LaborRequestCostSummaryReportTest < ActionDispatch::IntegrationTest
  include Minitest::Hooks

  def before_all
    @@spreadsheet = nil
    @@temp_file = nil
  end

  # @return [Roo::Spreadsheet] the spreadsheet to use for testing.
  def spreadsheet
    # Note: This code cannot be moved into the "before_all" method, because
    # Rails test fixtures are not available at the time that method is called.
    return @@spreadsheet if @@spreadsheet

    report_user = users(:test_user)
    report_params = { name: 'LaborRequestsCostSummaryReport', format: 'xlsx', user_id: report_user.id}
    report = Report.new(report_params)
    ReportJob.perform_now report
    report_id = report.id

    get report_download_url(id: report_id, format: 'xlsx')
    assert_response :success

    @@temp_file = Tempfile.new(['test_temp', '.xlsx'], encoding: 'ascii-8bit')

    @@temp_file.write response.body
    @@temp_file.close
    @@spreadsheet = Roo::Excelx.new(@@temp_file.path)
  end

  test 'spreadsheet should have worksheet for each division' do
    divisions = Division.all
    assert (divisions.count > 0)
    divisions.each do |div|
      div_code = div.code
      assert spreadsheet.sheets.include?(div_code)
    end
  end

  # Runs after all tests, and ensures that the temp file is deleted.
  def after_all
    @@temp_file.delete if @@temp_file
  end

end
