require 'test_helper'
require 'integration/personnel_requests_test_helper'

# Integration test for the ContractorRequest index page
class ContractorRequestsIndexTest < ActionDispatch::IntegrationTest
  include PersonnelRequestsTestHelper

  test 'currency field values show with two decimal places' do
    get contractor_requests_path

    doc = Nokogiri::HTML(response.body)
    currency_fields = %w(annual_base_pay nonop_funds)
    optional_fields = %w(nonop_funds)
    verify_two_digit_currency_fields(doc, currency_fields, optional_fields)
  end

  test 'index including pagination and sorting' do
    columns = %w(position_description employee_type_code request_type_code
                 contractor_name number_of_months annual_base_pay nonop_funds
                 division_code department_code unit_code review_status_id)

    get contractor_requests_path
    assert_template 'contractor_requests/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    columns.each do |sort_column|
      %w(asc desc).each do |sort_direction|
        q_param = { s: sort_column + ' ' + sort_direction }
        get contractor_requests_path, q: q_param
        assert_template 'contractor_requests/index'
        assert_select 'ul.pagination'

        # Verify sorting by getting the text of the page, then checking the
        # position of each entry -- the position should increase on each entry.
        page = response.body

        last_result_index = 0
        results = ContractorRequest.ransack(q_param).result.paginate(page: 1)
        results.each do |entry|
          entry_path = contractor_request_path(entry)
          entry_index = page.index(entry_path)
          assert_not_nil entry_index,
                         "'#{entry_path}' could not be found when sorting '#{sort_column} #{sort_direction}'"
          assert last_result_index < entry_index, "Failed for '#{q_param[:s]}'"
          assert_select 'tr td a[href=?]', entry_path
          last_result_index = entry_index
        end
      end
    end
  end

  test '"New" button should only be shown for users with roles' do
    run_as_user(users(:test_admin)) do
      get contractor_requests_path
      assert_select "[id='toolbar_new']"
    end

    no_role_user = User.create(cas_directory_id: 'no_role', name: 'No Role')
    run_as_user(no_role_user) do
      get contractor_requests_path
      assert_select "[id='toolbar_new']", 0
    end
    no_role_user.destroy!
  end
end
