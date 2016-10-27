# lib/tasks/sample_data.rake
namespace :db do
  desc 'Drop, create, migrate, seed and populate sample data'
  task reset_with_sample_data: [:drop, :create, :migrate, :seed, :populate_sample_data] do
    puts 'Ready to go!'
  end

  desc 'Populates the database with sample data'
  task populate_sample_data: :environment do
    num_staff_requests = 50
    num_staff_requests.times do
      valid_employee_types = EmployeeType.employee_types_with_category(StaffRequest::VALID_EMPLOYEE_CATEGORY_CODE)
      staff_request = create_staff_request(valid_employee_types)
      staff_request.save!
    end

    num_labor_requests = 50
    num_labor_requests.times do
      valid_employee_types = EmployeeType.employee_types_with_category(LaborRequest::VALID_EMPLOYEE_CATEGORY_CODE)
      labor_request = create_labor_request(valid_employee_types)
      labor_request.save!
    end

    num_contractor_requests = 50
    num_contractor_requests.times do
      valid_employee_types = EmployeeType.employee_types_with_category(ContractorRequest::VALID_EMPLOYEE_CATEGORY_CODE)
      contractor_request = create_contractor_request(valid_employee_types)
      contractor_request.save!
    end
  end

  # Returns a valid StaffRequest object
  def create_staff_request(valid_employee_types)
    staff_request = StaffRequest.new

    generate_common_fields(staff_request, valid_employee_types,
                           StaffRequest::VALID_REQUEST_TYPE_CODES)

    staff_request.employee_name = Faker::Name.name if staff_request.request_type_id == RequestType.find_by_code("PayAdj").id
    staff_request.annual_base_pay = (rand * 500_000.00).round(2)
    generate_nonop_fields(staff_request, staff_request.annual_base_pay)

    staff_request
  end

  # Returns a valid LaborRequest object
  # rubocop:disable Metrics/MethodLength
  def create_labor_request(valid_employee_types)
    labor_request = LaborRequest.new

    generate_common_fields(labor_request, valid_employee_types,
                           LaborRequest::VALID_REQUEST_TYPE_CODES)

    if labor_request.contractor_name_required?
      labor_request.contractor_name = Faker::Name.name
      labor_request.number_of_positions = 1
    else
      labor_request.number_of_positions = rand(20) + 1
    end

    generate_hourly_wage_fields(labor_request)
    max_funds = labor_request.hourly_rate * labor_request.hours_per_week * labor_request.number_of_weeks
    generate_nonop_fields(labor_request, max_funds)

    labor_request
  end

  # Returns a valid ContractorRequest object
  def create_contractor_request(valid_employee_types)
    contractor_request = ContractorRequest.new

    generate_common_fields(contractor_request, valid_employee_types,
                           ContractorRequest::VALID_REQUEST_TYPE_CODES)

    if contractor_request.contractor_name_required?
      contractor_request.contractor_name = Faker::Name.name
    end
    contractor_request.number_of_months = rand(12) + 1
    contractor_request.annual_base_pay =  (rand * 500_000.00).round(2)
    generate_nonop_fields(contractor_request, contractor_request.annual_base_pay)

    contractor_request
  end

  # Randomly populates the fields common to all requests for the given
  # +request+, choosing the employee type and request type from the
  # provided arrays of +valid_employee_type_ids+ and +valid_request_type_codes+
  def generate_common_fields(request, valid_employee_type_ids, valid_request_type_codes)
    request.position_title = Faker::Name.title
    request.employee_type = EmployeeType.find_by_id(valid_employee_type_ids.sample)
    request.request_type = RequestType.find_by_code(valid_request_type_codes.sample)

    generate_department_fields(request)
    request.justification = Faker::Lorem.words(rand(50) + 1).join(' ')
    generate_request_status(request)
  end

  # Randomly chooses to add nonop_funds and nonop_source entries to the given
  # +request+. The+max_funds+ parameter controls the maximum amount to use in
  # nonop_funds.
  def generate_nonop_fields(request, max_funds)
    has_nonop = rand > 0.6
    return unless has_nonop
    request.nonop_funds = (max_funds * rand).round(2)
    request.nonop_source = Faker::Company.name
  end

  # Randomly add a valid department and (possible) unit to the
  # given +request+.
  def generate_department_fields(request)
    has_unit = rand > 0.75
    if has_unit
      unit = Unit.all.to_a.sample
      request.unit = unit
      request.department = Department.find_by_id(unit.department_id)
    else
      request.department = Department.all.to_a.sample
    end
  end

  # Randomly add hourly wage fields to the given +request+
  def generate_hourly_wage_fields(request)
    request.hourly_rate = (rand * 100.0).round(2)
    request.hours_per_week = (rand * 40.0).to_i + 1
    request.number_of_weeks = (rand * 52).to_i + 1
  end

  # Randomly assign a request status and comment to the given +request+
  def generate_request_status(request)
    under_review_status = ReviewStatus.find_by_code('UnderReview')

    review_status = under_review_status

    review_status = ReviewStatus.all.sample if rand > 0.80

    request.review_status = review_status
    request.review_comment = Faker::Lorem.words(rand(50) + 1).join(' ') unless review_status == under_review_status
  end
end
