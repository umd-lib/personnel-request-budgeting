require 'reportable'
# A summary report for the costs of Labor and Assistance requests
class RequestCountsByReviewStatus
  include Reportable
  class << self
    # @return [String] human-readable description of the report, displayed in
    #   the GUI.
    def description
      'A report for the total counts of records, by their review status'
    end

    # @return [Array<String, Symbol>] the output formats this report is
    #   available in.
    def formats
      %w(xlsx)
    end

    # @return [String] the view template to use in formatting the report output
    def template
      'shared/request_counts_review_status'
    end
  end

  # @return [Object] the data used by the template
  def query # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    headers = {
      status: 'Review Status',
      contractor_count: "Contractor Request Count",
      labor_count: "Labor Request Count",
      staff_count: "Staff Request Count"
    }

    data = []
    ReviewStatus.all.to_a.each do |request|
      value = { 
        status: request.name,
        contractor_count: request.contractor_requests_count,
        labor_count: request.labor_requests_count,
        staff_count: request.staff_requests_count
      }
      data << value
    end

    [headers, data]
  end
end
