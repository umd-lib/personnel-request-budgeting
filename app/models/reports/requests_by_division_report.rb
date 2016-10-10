require 'reportable'

# A basic report that just gets all teh request types
class RequestsByDivisionReport
  include Reportable

  class << self
    def description
      'A basic report that collects requests by division'
    end

    def formats
      %w( xlsx )
    end

    def allowed_parameters
      %i( department_id )
    end

    # Here you add your worksheet tit to be made in the report
    def worksheets
      %w( StaffRequest ContractorRequest LaborRequest )
    end
  end

  # We are want a spreadsheet with pages with each of the R types with
  # departments
  def query
    [StaffRequest, ContractorRequest, LaborRequest].map do |klass|
      klass.where(department_id: parameters[:department_id]).find_each
    end
  end
end
