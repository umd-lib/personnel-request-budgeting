# Admins can record status of a request
class ReviewStatus < ActiveRecord::Base
  has_many :contractor_requests, dependent: :restrict_with_exception
  has_many :labor_requests, dependent: :restrict_with_exception
  has_many :staff_requests, dependent: :restrict_with_exception

  validates :name, presence: true

  def self.policy_class
    AdminOnlyPolicy
  end
end
