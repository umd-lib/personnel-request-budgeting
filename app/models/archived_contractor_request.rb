class ArchivedContractorRequest < ContractorRequest
  self.table_name = 'archived_requests'
  class << self
    def policy_class
      ArchivedRequestPolicy
    end
    # all the fields associated to the model
    def fields
      %i[ fiscal_year ] + ContractorRequest.fields
    end
  end
end
