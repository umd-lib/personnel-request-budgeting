require 'test_helper'

# Verifies subdepartment clear option on ContractorRequest "edit" page
class ClearSubdepartmentContractorRequestEditTest < ActionDispatch::IntegrationTest
  def setup
    @contractor_request = contractor_requests(:cont_fac_renewal)
    @contractor_request.department = departments(:as)
    @contractor_request.subdepartment = subdepartments(:ill)
    @contractor_request.save!
    @field_prefix = 'contractor_request'
    get edit_contractor_request_path(@contractor_request)
  end

  include ClearSubdepartmentDropdownTest
end

# Verifies subdepartment clear option on LaborRequest "edit" page
class ClearSubdepartmentLaborRequestEditTest < ActionDispatch::IntegrationTest
  def setup
    @labor_request = labor_requests(:c1)
    @labor_request.department = departments(:as)
    @labor_request.subdepartment = subdepartments(:ill)
    @labor_request.save!
    @field_prefix = 'labor_request'
    get edit_labor_request_path(@labor_request)
  end

  include ClearSubdepartmentDropdownTest
end

# Verifies subdepartment clear option on StaffRequest "edit" page
class ClearSubdepartmentStaffRequestEditTest < ActionDispatch::IntegrationTest
  def setup
    @staff_request = staff_requests(:fac)
    @staff_request.department = departments(:as)
    @staff_request.subdepartment = subdepartments(:ill)
    @staff_request.save!
    @field_prefix = 'staff_request'
    get edit_staff_request_path(@staff_request)
  end

  include ClearSubdepartmentDropdownTest
end
