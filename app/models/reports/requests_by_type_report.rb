require 'reportable'

# A basic report that just gets all teh request types
class RequestsByTypeReport
  include Reportable

  class << self
    def description
      'A basic report that collects all requests by type'
    end

    def formats
      %w( xlsx )
    end

    # Here you add your worksheet tit to be made in the report
    def worksheets
      %w( StaffRequest ContractorRequest LaborRequest )
    end
  end

  # this is actually not great....but, maybe we can figure this out..
  # currently, this loads all the requests into memory. idealls, we can
  # have this lazy load during iteration...
  def query
    [StaffRequest.enum_for(:find_each), ContractorRequest.enum_for(:find_each), LaborRequest.enum_for(:find_each)]
  end
end
