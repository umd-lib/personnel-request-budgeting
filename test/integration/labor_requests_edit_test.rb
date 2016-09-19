require 'test_helper'

# Integration test for the LaborRequest edit page
class LaborRequestsEditTest < ActionDispatch::IntegrationTest
  def setup
    @labor_request = labor_requests(:fac_hrly_renewal)
    @division1 = divisions_with_records[0]
    @division1_user = User.create(cas_directory_id: 'division1', name: 'Division1 User')
    Role.create!(user: @division1_user,
                 role_type: RoleType.find_by_code('division'),
                 division: @division1)
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
    run_as_user(@division1_user) do
      labor_requests_all = LaborRequest.all

      labor_requests_all.each do |r|
        get labor_request_path(r)
        if Pundit.policy!(@division1_user, r).edit?
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

    Role.destroy_all(user: @division1_user)
    @division1_user.destroy!
  end

  test 'can edit review_status or review_comments' do
    get edit_labor_request_path(@labor_request)
    assert_select "select#labor_request_review_status_id[disabled='disabled']", false
    assert_select "textarea#labor_request_review_comment[disabled='disabled']", false
  end

  test 'Non-admins cannot edit review_status or review_comments' do
    run_as_user(@division1_user) do
      get edit_labor_request_path(@labor_request)
      assert_select "select#labor_request_review_status_id[disabled='disabled']"
      assert_select "textarea#labor_request_review_comment[disabled='disabled']"
    end
  end
end
