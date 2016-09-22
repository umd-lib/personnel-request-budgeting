require 'test_helper'
require 'integration/personnel_requests_test_helper'

# Integration test for the ContractorRequest edit page
class ContractorRequestsEditTest < ActionDispatch::IntegrationTest
  include PersonnelRequestsTestHelper

  def setup
    @contractor_request = contractor_requests(:cont_fac_renewal)
    @division1 = divisions_with_records[0]
  end

  test 'currency field values show with two decimal places' do
    get edit_contractor_request_path(@contractor_request)

    currency_fields = %w(contractor_request_annual_base_pay contractor_request_nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        verify_two_digit_currency_field(field, e.attribute('value'))
      end
    end
  end

  test '"Edit" button should only be shown if policy allows edit' do
    with_temp_user(divisions: [@division1.code]) do |temp_user|
      run_as_user(temp_user) do
        contractor_requests_all = ContractorRequest.all

        contractor_requests_all.each do |r|
          get contractor_request_path(r)
          if Pundit.policy!(temp_user, r).edit?
            assert_select "[id='button_edit']", 1,
                          "'#{@division1.code}' user could NOT edit " \
                          "'#{r.id}' with division '#{r.department.division.code}'"
          else
            assert_select "[id='button_edit']", 0,
                          "'#{@division1.code}' user could edit " \
                          "'#{r.id}' with division '#{r.department.division.code}'"
          end
        end
      end
    end
  end

  test 'can edit review_status or review_comments' do
    get edit_contractor_request_path(@contractor_request)
    assert_select "select#contractor_request_review_status_id[disabled='disabled']", false
    assert_select "textarea#contractor_request_review_comment[disabled='disabled']", false
  end

  test 'Non-admins cannot edit review_status or review_comments' do
    with_temp_user(divisions: [@division1.code]) do |temp_user|
      run_as_user(temp_user) do
        get edit_contractor_request_path(@contractor_request)
        assert_select "select#contractor_request_review_status_id[disabled='disabled']"
        assert_select "textarea#contractor_request_review_comment[disabled='disabled']"
      end
    end
  end

  test 'can only see departments/units allowed by role in drop-downs' do
    contractor_request_with_unit = contractor_requests(:c2_with_unit)
    with_temp_user(units: [contractor_request_with_unit.unit.code]) do |temp_user|
      run_as_user(temp_user) do
        get edit_contractor_request_path(contractor_request_with_unit)

        # Verify department options
        expected_options = [contractor_request_with_unit.unit.department.name]
        verify_options(response, 'contractor_request_department_id', expected_options)

        # Verify unit options
        expected_options = ['<Clear Unit>', contractor_request_with_unit.unit.name]
        verify_options(response, 'contractor_request_unit_id', expected_options)
      end
    end
  end

  test 'can only see departments/units allowed by role in drop-downs with role cutoffs' do
    contractor_request = contractor_requests(:c2) # c2 is in SSDR department
    department_for_role = contractor_request.department
    unit_for_role = units(:one)
    with_temp_user(departments: [department_for_role.code], units: [unit_for_role.code]) do |temp_user|
      run_as_user(temp_user) do
        unit_role_cutoff = role_cutoffs(:unit)
        unit_role_cutoff.cutoff_date = 1.day.from_now
        unit_role_cutoff.save!

        get edit_contractor_request_path(contractor_request)

        # Verify department options
        expected_options = [unit_for_role.department.name, contractor_request.department.name]
        verify_options(response, 'contractor_request_department_id', expected_options)

        # Verify unit options
        expected_options = [unit_for_role.name]
        verify_options(response, 'contractor_request_unit_id', expected_options)

        unit_role_cutoff = role_cutoffs(:unit)
        unit_role_cutoff.cutoff_date = 1.day.ago
        unit_role_cutoff.save!

        get edit_contractor_request_path(contractor_request)

        # Verify department options - should no longer include department for unit
        expected_options = [contractor_request.department.name]
        verify_options(response, 'contractor_request_department_id', expected_options)

        # Verify unit options - should have no options
        expected_options = []
        verify_options(response, 'contractor_request_unit_id', expected_options)
      end
    end
  end
end
