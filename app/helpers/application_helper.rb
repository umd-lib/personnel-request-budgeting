module ApplicationHelper
  # simply removes the status if it is "UnderReview"
  def suppress_status(status)
    status == 'Under Review' ? '' : status
  end
end
