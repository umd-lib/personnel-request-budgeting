require 'reportable'
# A summary report for the requests count by review status
class RequestsCountByReviewStatus
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
    under_review = nil
    approved = nil
    not_approved = nil
    contingent = nil

    ReviewStatus.all.to_a.each do |request|
      status_count = Hash.new(0)
      status_count[:labor_count] = request.labor_requests_count
      status_count[:staff_count] = request.staff_requests_count
      status_count[:contractor_count] = request.contractor_requests_count
      if request.name == 'Under Review'
        under_review = status_count
      elsif request.name == 'Approved'
        approved = status_count
      elsif request.name == 'Not Approved'
        not_approved = status_count
      elsif request.name == 'Contingent'
        contingent = status_count
      end
    end

    category_display_name = Hash.new(0)
    category_display_name[:labor_count] = 'Labor and Assistance'
    category_display_name[:staff_count] = 'Staff'
    category_display_name[:contractor_count] = 'Salaried Contractor'

    category_order = [:labor_count, :staff_count, :contractor_count]

    data = []
    category_order.each do |key|
      value = {
        category: category_display_name[key],
        under_review: under_review[key],
        approved: approved[key],
        not_approved: not_approved[key],
        contingent: contingent[key]
      }
      data << value
    end

    data
  end
end
