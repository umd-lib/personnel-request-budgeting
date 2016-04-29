require 'test_helper'

# Verifies unit clear option on ContractorRequest "edit" page
class ClearUnitContractorRequestEditTest < ActionDispatch::IntegrationTest
  def setup
    @contractor_request = contractor_requests(:cont_fac_renewal)
    @contractor_request.department = departments(:as)
    @contractor_request.unit = units(:ill)
    @contractor_request.save!
    @field_prefix = 'contractor_request'
    get edit_contractor_request_path(@contractor_request)
  end

  include ClearUnitDropdownTest
end

# Verifies unit clear option on LaborRequest "edit" page
class ClearUnitLaborRequestEditTest < ActionDispatch::IntegrationTest
  def setup
    @labor_request = labor_requests(:c1)
    @labor_request.department = departments(:as)
    @labor_request.unit = units(:ill)
    @labor_request.save!
    @field_prefix = 'labor_request'
    get edit_labor_request_path(@labor_request)
  end

  include ClearUnitDropdownTest
end

# Verifies unit clear option on StaffRequest "edit" page
class ClearUnitStaffRequestEditTest < ActionDispatch::IntegrationTest
  def setup
    @staff_request = staff_requests(:fac)
    @staff_request.department = departments(:as)
    @staff_request.unit = units(:ill)
    @staff_request.save!
    @field_prefix = 'staff_request'
    get edit_staff_request_path(@staff_request)
  end

  include ClearUnitDropdownTest
end
