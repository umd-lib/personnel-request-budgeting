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
    # Stores annual cost totals, keyed by [department_code, emp_type_code]
    annual_cost_totals = Hash.new(0)

    # Stores nonop_fund totals, keyed by division_code
    other_support_totals = Hash.new(0)

    allowed_review_status_ids = parameters[:review_status_ids]
    allowed_review_statuses = allowed_review_status_ids.map { |id| ReviewStatus.find(id) }

    LaborRequest.includes(:department, :division, :employee_type, :review_status).each do |request|
      review_status = request.review_status
      next unless allowed_review_statuses.include?(review_status)
      emp_type_code = request.employee_type.code
      department_code = request.department.code
      key = [department_code, emp_type_code]
      annual_cost = request.annual_cost
      nonop_funds = request.nonop_funds
      annual_cost_totals[key] += annual_cost unless annual_cost.nil?
      other_support_key = [department_code, 'other_support']
      other_support_totals[other_support_key] += nonop_funds unless nonop_funds.nil?
    end

    # Stores in an array (to preserve the department ordering), a "value" Hash
    # representing that department's row in the table.
    summary_data = []
    Department.order(:code).each do |dept|
      department_code = dept.code
      division_code = dept.division.code
      c1_key = [department_code, 'C1']
      hourly_faculty_key = [department_code, 'FHRLY']
      students_key = [department_code, 'STUD']
      other_support_key = [department_code, 'other_support']
      value = { department: dept.name,
                division: division_code,
                c1: annual_cost_totals[c1_key],
                hourly_faculty: annual_cost_totals[hourly_faculty_key],
                students: annual_cost_totals[students_key],
                other_support: other_support_totals[other_support_key] }
      summary_data << value
    end

    divisions = Division.all
    current_fiscal_year = I18n.t(:current_fiscal_year)
    previous_fiscal_year = I18n.t(:previous_fiscal_year)

    { summary_data: summary_data, divisions: divisions,
      current_fiscal_year: current_fiscal_year,
      previous_fiscal_year: previous_fiscal_year,
      allowed_review_statuses: allowed_review_statuses }
  end
end
