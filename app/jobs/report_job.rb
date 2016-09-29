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

    klass = report.name.constantize
    record_set = klass.query

    output = ApplicationController.new
                                  .render_to_string(template: 'shared/index', formats: report.format,
                                                    locals: { klass: klass, record_set: record_set })

    report.update! status: 'completed', output: output
  end
end
