# Holds common methods for testing the personnel request index pages.
module PersonnelRequestIndexTestHelper
  # results: The results from a Ransack query
  def sort_and_paginate_results(results)
    results.paginate(page: 1)
  end
end
