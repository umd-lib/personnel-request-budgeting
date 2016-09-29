require 'test_helper'
require 'integration/personnel_requests_test_helper'

# Integration test for the StaffRequest index page
class StaffRequestsIndexTest < ActionDispatch::IntegrationTest
  include PersonnelRequestsTestHelper

  test 'currency field values show with two decimal places' do
    get staff_requests_path

    doc = Nokogiri::HTML(response.body)
    currency_fields = %w(annual_base_pay nonop_funds)
    optional_fields = %w(nonop_funds)
    verify_two_digit_currency_fields(doc, currency_fields, optional_fields)
  end

  test 'index including pagination and sorting' do
    columns = %w(position_description employee_type_code request_type_code
                 annual_base_pay nonop_funds division_code department_code
                 unit_code review_status_name)

    get staff_requests_path
    assert_template 'staff_requests/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    columns.each do |sort_column|
      %w(asc desc).each do |sort_direction|
        q_param = { s: sort_column + ' ' + sort_direction }
        get staff_requests_path, q: q_param
        assert_template 'staff_requests/index'
        assert_select 'ul.pagination'

        # Verify sorting by getting the text of the page, then checking the
        # position of each entry -- the position should increase on each entry.
        page = response.body

        last_result_index = 0
        results = StaffRequest.ransack(q_param).result.paginate(page: 1)
        results.each do |entry|
          entry_path = staff_request_path(entry)
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
      get staff_requests_path
      assert_select "[id='export']"

      get staff_requests_path(format: 'xlsx')
      assert_response :success
      wb = nil

      begin
        file = Tempfile.new(['staff_request', '.xlsx'])
        file.write(response.body)
        file.rewind
        assert_nothing_raised do
          wb = Roo::Excelx.new(file.path)
        end
        assert_equal Pundit.policy_scope!(users(:johnny_two_roles), StaffRequest).count + 1,
                     wb.sheet('StaffRequest').last_row
        assert_equal StaffRequest.fields.length + 1, wb.sheet('StaffRequest').last_column
      ensure
        file.close
        file.unlink
      end
    end
  end

  test 'index should download excel as an admin' do
    run_as_user(users(:test_admin)) do
      get staff_requests_path
      assert_select "[id='export']"

      get staff_requests_path(format: 'xlsx')
      assert_response :success
      wb = nil

      begin
        file = Tempfile.new(['staff_request', '.xlsx'])
        file.write(response.body)
        file.rewind
        assert_nothing_raised do
          wb = Roo::Excelx.new(file.path)
        end
        assert_equal StaffRequest.all.count + 1,
                     wb.sheet('StaffRequest').last_row
        assert_equal StaffRequest.fields.length + 1, wb.sheet('StaffRequest').last_column
      ensure
        file.close
        file.unlink
      end
    end
  end

  test '"New" button should only be shown for users with roles' do
    run_as_user(users(:test_admin)) do
      get staff_requests_path
      assert_select "[id='toolbar_new']"
    end

    no_role_user = User.create(cas_directory_id: 'no_role', name: 'No Role')
    run_as_user(no_role_user) do
      get staff_requests_path
      assert_select "[id='toolbar_new']", 0
    end
    no_role_user.destroy!
  end

  test '"Under Review" status should not be displayed but others should be' do
    review_statuses = [review_statuses(:under_review), review_statuses(:approved),
                       review_statuses(:not_approved), review_statuses(:contingent)]

    # Assign a review status to each request, using request id to pick the
    # status
    StaffRequest.find_each do |staff_request|
      id = staff_request.id
      staff_request.review_status_id = review_statuses[id % 4].id
      staff_request.save!
    end

    get staff_requests_path
    doc = Nokogiri::HTML(response.body)
    review_status_texts = doc.xpath("//td[@headers='review_status__name']").map(&:text).uniq
    assert review_status_texts.include?(review_statuses(:approved).name)
    assert review_status_texts.include?(review_statuses(:not_approved).name)
    assert review_status_texts.include?(review_statuses(:contingent).name)
    assert_not review_status_texts.include?(review_statuses(:under_review).name)
    assert review_status_texts.include?('')
  end

  test 'nonop funds label should be internationalized' do
    get staff_requests_path
    nonop_funds_i18n_key = 'activerecord.attributes.staff_request.nonop_funds'
    assert I18n.exists?(nonop_funds_i18n_key, :en)
    assert_select 'th#nonop_funds', { text: I18n.t(nonop_funds_i18n_key) },
                  "No label matching '#{I18n.t(nonop_funds_i18n_key)}' was found."
  end
end
