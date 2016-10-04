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
                 division_code department_code unit_code review_status_name)

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

  test 'index should download excel as a user with two roles' do
    run_as_user(users(:johnny_two_roles)) do
      get contractor_requests_path
      assert_select "[id='export']"

      get contractor_requests_path(format: 'xlsx')
      assert_response :success
      wb = nil

      begin
        file = Tempfile.new(['contractor_request', '.xlsx'])
        file.write(response.body)
        file.rewind
        assert_nothing_raised do
          wb = Roo::Excelx.new(file.path)
        end
        assert_equal Pundit.policy_scope!(users(:johnny_two_roles), ContractorRequest).count + 1,
                     wb.sheet('ContractorRequests').last_row
        assert_equal 17, wb.sheet('ContractorRequests').last_column
      ensure
        file.close
        file.unlink
      end
    end
  end

  test 'index should download excel as an admin' do
    run_as_user(users(:test_admin)) do
      get contractor_requests_path
      assert_select "[id='export']"

      get contractor_requests_path(format: 'xlsx')
      assert_response :success
      wb = nil

      begin
        file = Tempfile.new(['contractor_request', '.xlsx'])
        file.write(response.body)
        file.rewind
        assert_nothing_raised do
          wb = Roo::Excelx.new(file.path)
        end
        assert_equal ContractorRequest.all.count + 1,
                     wb.sheet('ContractorRequests').last_row
        assert_equal 17, wb.sheet('ContractorRequests').last_column
      ensure
        file.close
        file.unlink
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

  test '"Under Review" status should not be displayed but others should be' do
    review_statuses = [review_statuses(:under_review), review_statuses(:approved),
                       review_statuses(:not_approved), review_statuses(:contingent)]

    # Assign a review status to each request, using request id to pick the
    # status
    ContractorRequest.find_each do |contractor_request|
      id = contractor_request.id
      contractor_request.review_status_id = review_statuses[id % 4].id
      contractor_request.save!
    end

    get contractor_requests_path
    doc = Nokogiri::HTML(response.body)
    review_status_texts = doc.xpath("//td[@headers='review_status__name']").map(&:text).uniq
    assert review_status_texts.include?(review_statuses(:approved).name)
    assert review_status_texts.include?(review_statuses(:not_approved).name)
    assert review_status_texts.include?(review_statuses(:contingent).name)
    assert_not review_status_texts.include?(review_statuses(:under_review).name)
    assert review_status_texts.include?('')
  end

  test 'nonop funds label should be internationalized' do
    get contractor_requests_path
    verify_i18n_label('th#nonop_funds', 'activerecord.attributes.contractor_request.nonop_funds')
  end
end
