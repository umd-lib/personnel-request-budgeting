require 'test_helper'
require 'integration/personnel_requests_test_helper'

# Integration test for the LaborRequest edit page
class LaborRequestsEditTest < ActionDispatch::IntegrationTest
  include PersonnelRequestsTestHelper

  def setup
    @labor_request = labor_requests(:fac_hrly_renewal)
    @division1 = divisions_with_records[0]
  end

  test 'currency field values show with two decimal places' do
    get edit_labor_request_path(@labor_request)

    currency_fields = %w(labor_request_hourly_rate labor_request_nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        verify_two_digit_currency_field(field, e.attribute('value'))
      end
    end
  end

  test '"Edit" button should only be shown if policy allows edit' do
    with_temp_user(divisions: [@division1.code]) do |temp_user|
      run_as_user(temp_user) do
        labor_requests_all = LaborRequest.all

        labor_requests_all.each do |r|
          get labor_request_path(r)
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
    get edit_labor_request_path(@labor_request)
    assert_select "select#labor_request_review_status_id[disabled='disabled']", false
    assert_select "textarea#labor_request_review_comment[disabled='disabled']", false
  end

  test 'Non-admins cannot edit review_status or review_comments' do
    with_temp_user(divisions: [@division1.code]) do |temp_user|
      run_as_user(temp_user) do
        get edit_labor_request_path(@labor_request)
        assert_select "select#labor_request_review_status_id[disabled='disabled']"
        assert_select "textarea#labor_request_review_comment[disabled='disabled']"
      end
    end
  end

  test 'can only see departments/units allowed by role in drop-downs' do
    labor_request_with_unit = labor_requests(:fac_hrly_with_unit)
    with_temp_user(units: [labor_request_with_unit.unit.code]) do |temp_user|
      run_as_user(temp_user) do
        get edit_labor_request_path(labor_request_with_unit)

        # Verify department options
        expected_options = [labor_request_with_unit.unit.department.name]
        verify_options(response, 'labor_request_department_id', expected_options)

        # Verify unit options
        expected_options = ['<Clear Unit>', labor_request_with_unit.unit.name]
        verify_options(response, 'labor_request_unit_id', expected_options)
      end
    end
  end

  test 'can only see departments/units allowed by role in drop-downs with role cutoffs' do
    labor_request = labor_requests(:c1) # c1 is in SSDR department
    department_for_role = labor_request.department
    unit_for_role = units(:one)
    with_temp_user(departments: [department_for_role.code], units: [unit_for_role.code]) do |temp_user|
      run_as_user(temp_user) do
        unit_role_cutoff = role_cutoffs(:unit)
        unit_role_cutoff.cutoff_date = 1.day.from_now
        unit_role_cutoff.save!

        get edit_labor_request_path(labor_request)

        # Verify department options
        expected_options = [unit_for_role.department.name, labor_request.department.name]
        verify_options(response, 'labor_request_department_id', expected_options)

        # Verify unit options
        expected_options = [unit_for_role.name]
        verify_options(response, 'labor_request_unit_id', expected_options)

        unit_role_cutoff = role_cutoffs(:unit)
        unit_role_cutoff.cutoff_date = 1.day.ago
        unit_role_cutoff.save!

        get edit_labor_request_path(labor_request)

        # Verify department options - should no longer include department for unit
        expected_options = [labor_request.department.name]
        verify_options(response, 'labor_request_department_id', expected_options)

        # Verify unit options - should have no options
        expected_options = []
        verify_options(response, 'labor_request_unit_id', expected_options)
      end
    end
  end

  test 'nonop funds labels should be internationalized' do
    get edit_labor_request_path(@labor_request)
    verify_i18n_label("label[for='labor_request_nonop_funds']", 'activerecord.attributes.labor_request.nonop_funds')
    verify_i18n_label("label[for='labor_request_nonop_source']", 'activerecord.attributes.labor_request.nonop_source')
  end
end
