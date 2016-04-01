# A type of personnel request (New, Renewal, Pay Adjustment, etc.)
class RequestType < ActiveRecord::Base
  validates :code, presence: true
  validates :name, presence: true
end
