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
                 number_of_weeks nonop_funds division_code department_code
                 unit_code)

    get labor_requests_path
    assert_template 'labor_requests/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    columns.each do |sort_column|
      %w(asc desc).each do |sort_direction|
        q_param = { s: sort_column + ' ' + sort_direction }
        get labor_requests_path, q: q_param
        assert_template 'labor_requests/index'
        assert_select 'ul.pagination'

        # Verify sorting by getting the text of the page, then checking the
        # position of each entry -- the position should increase on each entry.
        page = response.body

        last_result_index = 0
        results = LaborRequest.ransack(q_param).result
        results = sort_and_paginate_results(results, sort_column, sort_direction)
        results.each do |entry|
          entry_path = labor_request_path(entry)
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

  private

    def sort_and_paginate_results(results, sort_column, sort_direction)
      if sort_column != 'division_code'
        results.paginate(page: 1)
      else
        # Division sorting needs additional join to access division code
        sort_order = "divisions.code #{sort_direction}"
        table_name = results.table_name
        results = results.joins("LEFT OUTER JOIN departments on departments.id = #{table_name}.department_id")
        results = results.joins('LEFT OUTER JOIN divisions on departments.division_id = divisions.id')
        results.order(sort_order).paginate(page: 1)
      end
    end
end
