module ReportsHelper
  def report_formats(report)
    (report.class.formats & Report.formats.keys)
  end
end
