# A type of staffing request (New, Renewal, Pay Adjustment, etc.)
class RequestType < ActiveRecord::Base
  has_many :contractor_requests, dependent: :restrict_with_exception
  has_many :labor_requests, dependent: :restrict_with_exception
  has_many :staff_requests, dependent: :restrict_with_exception
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # Convenience method that returns true if the current object can be deleted
  # (i.e. has no dependent records), false otherwise.
  def allow_delete?
    contractor_requests.empty? && labor_requests.empty? && staff_requests.empty?
  end
end
