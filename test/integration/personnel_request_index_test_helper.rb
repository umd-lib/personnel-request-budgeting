# Holds common methods for testing the personnel request index pages.
module PersonnelRequestIndexTestHelper
  # Sorts and paginates the given results, using the given parameters.
  # This method is needed because the personnel requests can be sorted
  # by Division, which requires additional joins to enable.
  #
  # results: The results from a Ransack query
  # sort_column: The column being sorted
  # sort_direction: The direction of the sort, either 'asc' or 'desc'
  def sort_and_paginate_results(results)
    results.paginate(page: 1)
  end
end
