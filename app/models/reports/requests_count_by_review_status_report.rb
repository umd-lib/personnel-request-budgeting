require 'reportable'
# A summary report for the requests count by review status
class RequestCountsByReviewStatus
  include Reportable
  class << self
    # @return [String] human-readable description of the report, displayed in
    #   the GUI.
    def description
      'A report for the total count of requests, by their review status'
    end

    # @return [Array<String, Symbol>] the output formats this report is
    #   available in.
    def formats
      %w(xlsx)
    end

    # @return [String] the view template to use in formatting the report output
    def template
      'shared/requests_count_review_status'
    end
  end

  # @return [Object] the data used by the template
  def query # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

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

    data
  end
end
