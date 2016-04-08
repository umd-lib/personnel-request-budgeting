# A type of personnel request (New, Renewal, Pay Adjustment, etc.)
class RequestType < ActiveRecord::Base
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
