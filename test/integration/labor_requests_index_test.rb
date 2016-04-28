require 'test_helper'

# Integration test for the LaborRequest index page
class LaborRequestsIndexTest < ActionDispatch::IntegrationTest
  test 'currency field values show with two decimal places' do
    get labor_requests_path

    currency_fields = %w(hourly_rate nonop_funds)
    currency_fields.each do |field|
      assert_select "td[headers=#{field}]", { text: /\d\.\d\d/ },
                    "#{field} should have two decimal places"
    end
  end

  test 'index including pagination and sorting' do
    columns = %w(position_description employee_type_code request_type_code
                 contractor_name number_of_positions hourly_rate hours_per_week
                 number_of_weeks nonop_funds department_code unit_code)

    get labor_requests_path
    assert_template 'labor_requests/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get labor_requests_path, q: q_param
        assert_template 'labor_requests/index'
        assert_select 'ul.pagination'
        LaborRequest.ransack(q_param).result.paginate(page: 1).each do |entry|
          assert_select 'a[href=?]', labor_request_path(entry)
        end
      end
    end
  end
end
