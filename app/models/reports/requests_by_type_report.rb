require 'reportable'

# A basic report that just gets all the request types
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

  def query
    [StaffRequest.enum_for(:find_each), ContractorRequest.enum_for(:find_each), LaborRequest.enum_for(:find_each)]
  end
end
