require 'test_helper'

# Integration test for the LaborRequest edit page
class LaborRequestsEditTest < ActionDispatch::IntegrationTest
  def setup
    @labor_request = labor_requests(:fac_hrly_renewal)
  end

  test 'currency field values show with two decimal places' do
    get edit_labor_request_path(@labor_request)

    currency_fields = %w(labor_request_hourly_rate labor_request_nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        assert_match(/\d\.\d\d/, e.attribute('value'),
                     "#{field} should have two decimal places")
      end
    end
  end

  test '"Edit" button should only be shown if policy allows edit' do
    @division1 = divisions_with_records[0]
    @division1_user = User.create(cas_directory_id: 'division1', name: 'Division1 User')
    Role.create!(user: @division1_user,
                 role_type: RoleType.find_by_code('division'),
                 division: @division1)

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
end
