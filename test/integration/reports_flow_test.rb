require 'test_helper'

# Integration test for various parts of the reports workflow
class ReportFlowTest < ActionDispatch::IntegrationTest
  test 'should be able to make a new report' do
    get new_report_path
    assert_select "form[id='requests_by_type_report__new_report']" do |_el|
      assert_select "[id='requests_by_type_report__report_format']"
      assert_select "input[type='submit']"
    end
  end

  test 'should be able to download an excel' do
    report = reports(:requests_by_type)
    ReportJob.perform_later report

    get report_download_path(report, format: report.format)
    assert_response :success
    wb = nil

    begin
      file = Tempfile.new(['report', '.xlsx'])
      file.binmode
      file.write(response.body)
      file.rewind
      assert_nothing_raised do
        wb = Roo::Excelx.new(file.path)
      end
      [ContractorRequest, StaffRequest, LaborRequest].each do |klass|
        assert_equal klass.count + 1, wb.sheet(klass.to_s.pluralize).last_row
      end
    ensure
      file.close
      file.unlink
    end
  end
end
