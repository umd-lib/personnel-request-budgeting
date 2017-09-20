# A Request that has been moved to the archived table
class ArchivedRequest < ApplicationRecord
  belongs_to :review_status, counter_cache: true
  belongs_to :organization, required: true, counter_cache: true
end
