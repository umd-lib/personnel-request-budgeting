require 'reportable'

# A basic report that just gets all the request types
class RequestsByDepartmentReport
  include Reportable

  class << self
    def description
      'A basic report that collects requests by department'
    end

    def formats
      %w( xlsx )
    end

    def allowed_parameters
      %i( department_id )
    end

    def worksheets
      %w( StaffRequest ContractorRequest LaborRequest )
    end

    def template
      'shared/index'
    end
  end

  def query
    [StaffRequest, ContractorRequest, LaborRequest].map do |klass|
      klass.where(department_id: parameters[:department_id]).find_each
    end
  end
end
