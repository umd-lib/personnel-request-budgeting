require 'reportable'
# A summary report for the costs of Labor and Assistance requests
class LaborRequestsCostSummaryReport
  include Reportable
  class << self
    def description
      'A summary report for the costs of Labor and Assistance requests, by division'
    end
    def formats
      %w( xlsx )
    end
    # Here you add your worksheets to be made in the report
    def worksheets
      %w( LaborRequest )
    end

    def template
      'shared/labor_requests_cost_summary'
    end
  end
  def query
    request_types = {}
    headers = {
      division: 'Div Name',
      c1: "C1's",
      hourly_faculty: 'Hourly Faculty',
      students: 'Students',
      other_support: 'Other Support'
    }


    annual_cost_totals = Hash.new(0)
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

#    data = [ { division: 'ASD',
#               c1: nil,
#               hourly_faculty: nil,
#               students: 5689.45,
#               other_support: nil },
#             { division: 'CSS',
#               c1: 26660.00,
#               hourly_faculty: 56150.00,
#               students: 141495.00,
#               other_support: 16160.00 },
#             { division: 'DO',
#               c1: nil,
#               hourly_faculty: nil,
#               students: 27713.00,
#               other_support: nil },
#             { division: 'DSS',
#               c1: 68880,
#               hourly_faculty: nil,
#               students: 110100.00,
#               other_support: 65040.00 },
#             { division: 'PSD',
#               c1: 269031.00,
#               hourly_faculty: 45654.00,
#               students: 788053.00,
#               other_support: 153934.00 } ]


#    [LaborRequest.enum_for(:find_each)]
    [headers, data]
  end
end