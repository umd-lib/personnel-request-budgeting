# lib/tasks/sample_data.rake
namespace :db do
  desc 'Drop, create, migrate, seed and populate sample data'
  task reset_with_sample_data: [:drop, :create, :migrate, :seed, :populate_sample_data] do
    puts 'Ready to go!'
  end

  desc 'Populates the database with sample data'
  task populate_sample_data: :environment do
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
  end
end
