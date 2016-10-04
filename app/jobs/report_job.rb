require 'report_generator'
# A job to submit reports and run in background
class ReportJob < ActiveJob::Base
  queue_as :default

  # The method used to run the report by rails.
  def perform(*reports)
    reports.each do |report|
      begin
        run_report(report)
      rescue => e
        report.update_attributes status:  'error'
        raise e
      end
    end
  end

  # Run the individual report
  def run_report(report)
    report.update! status: 'running'

    output = ReportGenerator.generate(report)
    report.update! status: 'completed', output: output
  end
end
