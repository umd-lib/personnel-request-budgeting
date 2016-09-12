# Admins can record status of a request
class ReviewStatus < ActiveRecord::Base
  validates :name, presence: true

  def self.policy_class
    AdminOnlyPolicy
  end
end
