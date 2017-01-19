require 'test_helper'
require 'minitest/hooks/test'

# Integration test for various parts of the reports workflow
class LaborRequestCostSummaryReportTest < ActionDispatch::IntegrationTest
  include Minitest::Hooks

  def before_all
    @@spreadsheet = nil
  end

  def setup
    spreadsheet unless @@spreadsheet
  end

  # @return [Roo::Spreadsheet] the spreadsheet to use for testing.
  def spreadsheet
    # Note: This code cannot be moved into the "before_all" method, because
    # Rails test fixtures are not available at the time that method is called.
    return @@spreadsheet if @@spreadsheet

    # Set review status ids to include in the report
    review_status_ids = ReviewStatus.all.map(&:id)

    report_user = users(:test_user)
    @@report_params = { name: 'LaborRequestsCostSummaryReport',
                        format: 'xlsx',
                        user_id: report_user.id,
                        parameters: { review_status_ids: review_status_ids }
                      }
    report = Report.new(@@report_params)
    ReportJob.perform_now report
    report_id = report.id
    @@creation_date = report.created_at

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
      # Sheet names should not have underscores or spaces
      div_code = div.code.delete(' ').delete('_')
      assert spreadsheet.sheets.include?(div_code)
    end
  end

  test 'each worksheet should contain parameter information about the report' do
    review_status_ids = @@report_params[:parameters][:review_status_ids]
    review_status_description = review_status_ids.map { |id| ReviewStatus.find(id).name }.join(', ')

    spreadsheet.each_with_pagename do |name, sheet|
      parsed = sheet.parse
      assert(parsed.any? { |e| e.to_s.include?(review_status_description) },
        "Could not find parameter information on '#{name}' worksheet")
    end
  end

  test 'each worksheet should indicate the report creation date' do
    spreadsheet.each_with_pagename do |name, sheet|
      parsed = sheet.parse
      assert(parsed.any? { |e| e.to_s.include?("#{@@creation_date}") },
        "Could not find creation date on '#{name}' worksheet")
    end
  end

  test 'generating report without parameters will display error message on report detail page' do
    report_user = users(:test_user)
    report_params = { name: 'LaborRequestsCostSummaryReport',
                      format: 'xlsx',
                      user_id: report_user.id,
                      parameters: {}
                    }
    report = Report.new(report_params)
    ReportJob.perform_now report
    report_id = report.id

    get report_download_url(id: report_id, format: 'xlsx')
    assert_response :success
    assert report.error?

    # Retrieve the report detail page
    get report_url(id: report_id)
    assert_select 'span#status_message'
  end

  # Runs after all tests, and ensures that the temp file is deleted.
  def after_all
    @@temp_file.delete if @@temp_file
  end
end
