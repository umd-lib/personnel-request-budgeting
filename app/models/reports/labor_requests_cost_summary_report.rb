require 'reportable'
# A summary report for the costs of Labor and Assistance requests
class LaborRequestsCostSummaryReport
  include Reportable
  class << self
    # @return [String] human-readable description of the report, displayed in
    #   the GUI.
    def description
      'A summary report for the costs of Labor and Assistance requests, by division'
    end

    # @return [Array<String, Symbol>] the output formats this report is
    #   available in.
    def formats
      %w(xlsx)
    end

    # @return [String] the view template to use in formatting the report output
    def template
      'shared/labor_requests_cost_summary'
    end
  end

  # @return [Object] the data used by the template
  def query # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    headers = {
      division: 'Div Name',
      c1: "C1's",
      hourly_faculty: 'Hourly Faculty',
      students: 'Students',
      other_support: 'Other Support'
    }

    # Stores annual cost totals, keyed by [division_code, emp_type_code]
    annual_cost_totals = Hash.new(0)

    # Stores nonop_fund totals, keyed by division_code
    other_support_totals = Hash.new(0)

    LaborRequest.includes(:department, :division, :employee_type).each do |request|
      division_code = request.division.code
      emp_type_code = request.employee_type.code
      key = [division_code, emp_type_code]
      annual_cost = request.annual_cost
      nonop_funds = request.nonop_funds
      annual_cost_totals[key] += annual_cost unless annual_cost.nil?
      other_support_totals[division_code] += nonop_funds unless nonop_funds.nil?
    end

    # Stores in an array (to preserve the division ordering), a "value" Hash
    # representing that division's row in the table.
    data = []
    Division.order(:code).each do |div|
      division_code = div.code
      c1_key = [division_code, 'C1']
      hourly_faculty_key = [division_code, 'FAC-Hrly']
      students_key = [division_code, 'Student']
      value = { division: division_code,
                c1: annual_cost_totals[c1_key],
                hourly_faculty: annual_cost_totals[hourly_faculty_key],
                students: annual_cost_totals[students_key],
                other_support: other_support_totals[division_code] }
      data << value
    end

    [headers, data]
  end
end
