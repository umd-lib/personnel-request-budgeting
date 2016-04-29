require 'test_helper'

# Verifies sorted dropdowns in ContractorRequest "new" page
class SortedDropdownFieldsContractorRequestNewTest < ActionDispatch::IntegrationTest
  def setup
    get new_contractor_request_path
    @field_prefix = 'contractor_request'
    @valid_category_code = ContractorRequest::VALID_EMPLOYEE_CATEGORY_CODE
    @valid_request_type_codes = ContractorRequest::VALID_REQUEST_TYPE_CODES
  end

  include DepartmentDropdownTest
  include UnitDropdownTest
  include EmployeeTypeDropdownTest
  include RequestTypeDropdownTest
end

# Verifies sorted dropdowns in LaborRequest "new" page
class SortedDropdownFieldsLaborRequestNewTest < ActionDispatch::IntegrationTest
  def setup
    get new_labor_request_path
    @field_prefix = 'labor_request'
    @valid_category_code = LaborRequest::VALID_EMPLOYEE_CATEGORY_CODE
    @valid_request_type_codes = LaborRequest::VALID_REQUEST_TYPE_CODES
  end

  include DepartmentDropdownTest
  include UnitDropdownTest
  include EmployeeTypeDropdownTest
  include RequestTypeDropdownTest
end

# Verifies sorted dropdowns in StaffRequest "new" page
class SortedDropdownFieldsStaffRequestNewTest < ActionDispatch::IntegrationTest
  def setup
    get new_staff_request_path
    @field_prefix = 'staff_request'
    @valid_category_code = StaffRequest::VALID_EMPLOYEE_CATEGORY_CODE
    @valid_request_type_codes = StaffRequest::VALID_REQUEST_TYPE_CODES
  end

  include DepartmentDropdownTest
  include UnitDropdownTest
  include EmployeeTypeDropdownTest
  include RequestTypeDropdownTest
end

# Verifies sorted dropdowns in Department "new" page
class SortedDropdownFieldsDepartmentNewTest < ActionDispatch::IntegrationTest
  def setup
    get new_department_path
    @field_prefix = 'department'
  end

  include DivisionDropdownTest
end

# Verifies sorted dropdowns in Unit "new" page
class SortedDropdownFieldsUnitNewTest < ActionDispatch::IntegrationTest
  def setup
    get new_unit_path
    @field_prefix = 'unit'
  end

  include DepartmentDropdownTest
end

# Verifies sorted dropdowns in Employee Type "new" page
class SortedDropdownFieldsEmployeeTypeNewTest < ActionDispatch::IntegrationTest
  def setup
    get new_employee_type_path
    @field_prefix = 'employee_type'
  end

  include EmployeeCategoryDropdownTest
end
