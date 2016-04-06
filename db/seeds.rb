# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Divisions
divisions = [{ code: 'ASD', name: 'Administrative Services' },
             { code: 'CSS', name: 'Collections Strategies & Services' },
             { code: 'DO', name: "Dean's Office" },
             { code: 'DSS', name: 'Digital Systems & Stewardship' },
             { code: 'PSD', name: 'Public Services' }]

divisions.each { |div| Division.create!(div) }

# Departments
departments_by_division = {
  'ASD' => [{ code: 'BBS', name: 'Budget & Business Services' },
            { code: 'LF', name: 'Libraries Facilities' },
            { code: 'LHR', name: 'Libraries Human Resources' }],
  'CSS' => [{ code: 'ACQ', name: 'Acquisitions' },
            { code: 'CD', name: 'Collections Development' },
            { code: 'MDS', name: 'Metadata Services' },
            { code: 'PRG', name: 'Prange' },
            { code: 'SCUA', name: 'Special Collections & University Archives' }],
  'DO' => [{ code: 'COM', name: 'Communications' },
           { code: 'DO', name: "Dean's Office" }],
  'DSS' => [{ code: 'DCMR', name: 'Digitization' },
            { code: 'DDS', name: 'Digital Data Services' },
            { code: 'DPI', name: 'Digital Preservation Initiatives' },
            { code: 'SSDR', name: 'Software Systems Development and Research' },
            { code: 'USS', name: 'User Systems & Support' }],
  'PSD' => [{ code: 'AS', name: 'Access Services' },
            { code: 'LMS', name: 'Library Media Services' },
            { code: 'PS', name: 'Public Services' },
            { code: 'RL', name: 'Research & Learning' }] }

departments_by_division.each do |division_code, departments|
  division = Division.find_by_code(division_code)
  departments.each do |dept|
    division.departments.create!(dept)
  end
end

# Subdepartments
subdepartments_by_department = {
  'AS' => [{ code: 'ILL', name: 'Interlibrary Loan' },
           { code: 'LN', name: 'Late Night' },
           { code: 'LSD', name: 'Library Services Desk' },
           { code: 'STK', name: 'Stacks' },
           { code: 'TLC', name: 'Terapin Learning Commons' }],
  'RL' => [{ code: 'ARCH', name: 'Architecture Library' },
           { code: 'ART', name: 'Art Library' },
           { code: 'CHEM', name: 'Chemistry Library' },
           { code: 'EPSL', name: 'Engineering & PS Library' },
           { code: 'HSSL', name: 'Humanities & Social Services' },
           { code: 'MSPAL', name: 'Performing Arts Library' },
           { code: 'RC', name: 'Research Commons' },
           { code: 'RL', name: 'Research & Learning' },
           { code: 'TL', name: 'Teaching & Learning' }] }

subdepartments_by_department.each do |department_code, subdepartments|
  department = Department.find_by_code(department_code)
  subdepartments.each do |subdept|
    department.subdepartments.create!(subdept)
  end
end

# Employee Categories
employee_categories = [{ code: 'L&A', name: 'Labor & Assistance' },
                       { code: 'Reg/GA', name: 'Regular Staff/GA' },
                       { code: 'SC', name: 'Salaried Contractor' }]

employee_categories.each { |category| EmployeeCategory.create!(category) }

# Employee Types
employee_types_by_category = {
  'L&A' => [{ code: 'C1', name: 'Contractor Type 1' },
            { code: 'FAC-Hrly', name: 'Faculty Hourly' },
            { code: 'Student', name: 'Student' }],
  'Reg/GA' => [{ code: 'Ex', name: 'Ex' },
               { code: 'Fac', name: 'Faculty' },
               { code: 'GA', name: 'Graduate Assistant' },
               { code: 'Nex', name: 'Nex' }],
  'SC' => [{ code: 'C2', name: 'Contractor Type 2' },
           { code: 'ContFac', name: 'ContFac' }] }

employee_types_by_category.each do |category_code, employee_types|
  category = EmployeeCategory.find_by_code(category_code)
  employee_types.each do |type|
    category.employee_types.create!(type)
  end
end

# Request Types
request_types = [{ code: 'ConvertC1', name: 'ConvertC1' },
                 { code: 'ConvertCont', name: 'ConvertCont' },
                 { code: 'New', name: 'New' },
                 { code: 'PayAdj', name: 'Pay Adjustment' },
                 { code: 'Renewal', name: 'Renewal' }]

request_types.each { |type| RequestType.create!(type) }

# Sample data
staff_requests = [
  { employee_type: 'Fac',
    position_description: 'Video game archive librarian',
    request_type: 'New',
    annual_base_pay: 1_000_000.00,
    nonop_funds: 900_000.00,
    nonop_source: 'Google Grant',
    department: 'SCUA',
    subdepartment: nil,
    justification: 'Because video games are a new art form and should be preserved.' },
  { employee_type: 'GA',
    position_description: 'Video game graduate assistant',
    request_type: 'New',
    annual_base_pay: 50_000.00,
    nonop_funds: 40_000.00,
    nonop_source: 'Google Grant',
    department: 'SCUA',
    subdepartment: nil,
    justification: 'Because every professor needs a graduate assistant.' },
  { employee_type: 'Ex',
    position_description: 'Gofer',
    request_type: 'ConvertCont',
    annual_base_pay: 40_000.00,
    nonop_funds: 0.00,
    nonop_source: nil,
    department: 'AS',
    subdepartment: 'STK',
    justification: 'We need someone to re-shelve the books.' }
]

staff_requests.each do |request|
  staff_request = StaffRequest.new
  staff_request.employee_type = EmployeeType.find_by_code(request[:employee_type])
  staff_request.position_description = request[:position_description]
  staff_request.request_type = RequestType.find_by_code(request[:request_type])
  staff_request.annual_base_pay = request[:annual_base_pay]
  staff_request.nonop_funds = request[:nonop_funds]
  staff_request.nonop_source = request[:nonop_source]
  staff_request.department = Department.find_by_code(request[:department])
  staff_request.subdepartment = Subdepartment.find_by_code(request[:subdepartment]) if request[:subdepartment]
  staff_request.justification = request[:justification]
  staff_request.save!
end

labor_requests = [
  {  employee_type: 'FAC-Hrly',
     position_description: 'Medieval Plumbing Librarian',
     request_type: 'Renewal',
     contractor_name: 'Luke O. Below',
     number_of_positions: 1,
     hourly_rate: 200.00,
     hours_per_week: 40.00,
     number_of_weeks: 12,
     nonop_funds: nil,
     nonop_source: nil,
     department: 'SCUA',
     subdepartment: nil,
     justification: "Can't have enough expertise for this topic." },
  {  employee_type: 'Student',
     position_description: 'General Factotum',
     request_type: 'New',
     contractor_name: nil,
     number_of_positions: 5,
     hourly_rate: 15.00,
     hours_per_week: 20.00,
     number_of_weeks: 16,
     nonop_funds: 2000.00,
     nonop_source: 'Federal Factotum Initiative',
     department: 'AS',
     subdepartment: 'TLC',
     justification: 'Need more factotums.' }
]

labor_requests.each do |request|
  labor_request = LaborRequest.new
  labor_request.employee_type = EmployeeType.find_by_code(request[:employee_type])
  labor_request.position_description = request[:position_description]
  labor_request.request_type = RequestType.find_by_code(request[:request_type])
  labor_request.contractor_name = request[:contractor_name]
  labor_request.number_of_positions = request[:number_of_positions]
  labor_request.hourly_rate = request[:hourly_rate]
  labor_request.hours_per_week = request[:hours_per_week]
  labor_request.number_of_weeks = request[:number_of_weeks]
  labor_request.nonop_funds = request[:nonop_funds]
  labor_request.nonop_source = request[:nonop_source]
  labor_request.department = Department.find_by_code(request[:department])
  labor_request.subdepartment = Subdepartment.find_by_code(request[:subdepartment]) if request[:subdepartment]
  labor_request.justification = request[:justification]
  labor_request.save!
end

contractor_requests = [
  {  employee_type: 'C2',
     position_description: 'Programmer',
     request_type: 'New',
     contractor_name: nil,
     number_of_months: 6,
     annual_base_pay: 100_000.00,
     nonop_funds: nil,
     nonop_source: nil,
     department: 'SSDR',
     subdepartment: nil,
     justification: 'Always need more programmers' },
  {  employee_type: 'ContFac',
     position_description: 'Superhero Studies Librarian',
     request_type: 'Renewal',
     contractor_name: 'Clark Kent',
     number_of_months: 12,
     annual_base_pay: 50_000.00,
     nonop_funds: 40_000.00,
     nonop_source: 'Daily Planet',
     department: 'RL',
     subdepartment: 'HSSL',
     justification: "Because he's SUPER!" }
]

contractor_requests.each do |request|
  contractor_request = ContractorRequest.new
  contractor_request.employee_type = EmployeeType.find_by_code(request[:employee_type])
  contractor_request.position_description = request[:position_description]
  contractor_request.request_type = RequestType.find_by_code(request[:request_type])
  contractor_request.contractor_name = request[:contractor_name]
  contractor_request.number_of_months = request[:number_of_months]
  contractor_request.annual_base_pay = request[:annual_base_pay]
  contractor_request.nonop_funds = request[:nonop_funds]
  contractor_request.nonop_source = request[:nonop_source]
  contractor_request.department = Department.find_by_code(request[:department])
  contractor_request.subdepartment = Subdepartment.find_by_code(request[:subdepartment]) if request[:subdepartment]
  contractor_request.justification = request[:justification]
  contractor_request.save!
end
