require 'test_helper'

# Integration test for the StaffRequest index page
class StaffRequestsIndexTest < ActionDispatch::IntegrationTest
  test 'currency field values show with two decimal places' do
    get staff_requests_path

    currency_fields = %w(annual_base_pay nonop_funds)
    currency_fields.each do |field|
      assert_select "td[headers=#{field}]", { text: /\d\.\d\d/ },
                    "#{field} should have two decimal places"
    end
  end

  test 'index including pagination and sorting' do
    columns = %w(position_description employee_type_code request_type_code
                 annual_base_pay nonop_funds department_code subdepartment_code)
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get staff_requests_path, q: q_param
        assert_template 'staff_requests/index'
        assert_select 'ul.pagination'
        StaffRequest.ransack(q_param).result.paginate(page: 1).each do |entry|
          assert_select 'a[href=?]', staff_request_path(entry)
        end
      end
    end
  end
end
