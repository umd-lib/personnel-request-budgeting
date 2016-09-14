# Holds common methods for testing the personnel request index pages.
module PersonnelRequestIndexTestHelper
  # Sorts and paginates the given results, using the given parameters.
  # This method is needed because the personnel requests can be sorted
  # by Division, which requires additional joins to enable.
  #
  # results: The results from a Ransack query
  # sort_column: The column being sorted
  # sort_direction: The direction of the sort, either 'asc' or 'desc'
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
