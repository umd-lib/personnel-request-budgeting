require 'test_helper'

# Integration test for the ContractorRequest edit page
class ContractorRequestsEditTest < ActionDispatch::IntegrationTest
  def setup
    @contractor_request = contractor_requests(:cont_fac_renewal)
    @division1 = divisions_with_records[0]
    @division1_user = User.create(cas_directory_id: 'division1', name: 'Division1 User')
    Role.create!(user: @division1_user,
                 role_type: RoleType.find_by_code('division'),
                 division: @division1)
  end

  test 'currency field values show with two decimal places' do
    get edit_contractor_request_path(@contractor_request)

    currency_fields = %w(contractor_request_annual_base_pay contractor_request_nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        assert_match(/\d\.\d\d/, e.attribute('value'),
                     "#{field} should have two decimal places")
      end
    end
  end

  test '"Edit" button should only be shown if policy allows edit' do
    run_as_user(@division1_user) do
      contractor_requests_all = ContractorRequest.all

      contractor_requests_all.each do |r|
        get contractor_request_path(r)
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
    get edit_contractor_request_path(@contractor_request)
    assert_select "select#contractor_request_review_status_id[disabled='disabled']", false
    assert_select "textarea#contractor_request_review_comment[disabled='disabled']", false
  end

  test 'Non-admins cannot edit review_status or review_comments' do
    run_as_user(@division1_user) do
      get edit_contractor_request_path(@contractor_request)
      assert_select "select#contractor_request_review_status_id[disabled='disabled']"
      assert_select "textarea#contractor_request_review_comment[disabled='disabled']"
    end
  end
end
