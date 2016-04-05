class ContractorRequest < ActiveRecord::Base
  belongs_to :employee_type
  belongs_to :request_type
  belongs_to :department
  belongs_to :subdepartment
end
