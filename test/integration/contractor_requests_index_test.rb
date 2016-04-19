require 'test_helper'

# Integration test for the ContractorRequest index page
class ContractorRequestsIndexTest < ActionDispatch::IntegrationTest
  test 'currency field values show with two decimal places' do
    get contractor_requests_path

    currency_fields = %w(annual_base_pay nonop_funds)
    currency_fields.each do |field|
      assert_select "td[headers=#{field}]", { text: /\d\.\d\d/ },
                    "#{field} should have two decimal places"
    end
  end

  test 'index including pagination and sorting' do
    columns = %w(position_description employee_type_code request_type_code
                 contactor_name number_of_months annual_base_pay nonop_funds
                 department_code subdepartment_code)
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get contractor_requests_path, q: q_param
        assert_template 'contractor_requests/index'
        assert_select 'ul.pagination'
        ContractorRequest.ransack(q_param).result.paginate(page: 1).each do |entry|
          assert_select 'a[href=?]', contractor_request_path(entry)
        end
      end
    end
  end
end
