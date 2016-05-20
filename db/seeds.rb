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

# Units
units_by_department = {
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

units_by_department.each do |department_code, units|
  department = Department.find_by_code(department_code)
  units.each do |unit|
    department.units.create!(unit)
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
  'Reg/GA' => [{ code: 'Ex', name: 'Exempt' },
               { code: 'Fac', name: 'Faculty' },
               { code: 'GA', name: 'Graduate Assistant' },
               { code: 'Nex', name: 'Non-exempt' }],
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

# Role Types
role_types = [{ code: 'admin', name: 'Admin' },
              { code: 'division', name: 'Division' },
              { code: 'department', name: 'Department' },
              { code: 'unit', name: 'Unit' }]

role_types.each { |type| RoleType.create!(type) }

User.create!(cas_directory_id: 'dsteelma', name: 'David P. Steelman')

roles = [{ user: 'dsteelma', role_type: 'department', department: 'ACQ' }]
roles.each do |role|
  user = User.find_by_cas_directory_id(role[:user])
  role_type = RoleType.find_by_code(role[:role_type])
  department = Department.find_by_code(role[:department])

  Role.create!(user: user, role_type: role_type, department: department)
end
