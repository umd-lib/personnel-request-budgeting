# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module PersonnelRequestController
  # Sets the @selectable_units and @selectable_department variables for the
  # given personnel request and current user.
  #
  # personnel_request: The personnel request shown in the GUI.
  def assign_selectable_departments_and_units(personnel_request)
    @selectable_units = policy(personnel_request).selectable_units(@current_user).sort_by(&:name)
    @selectable_departments = policy(personnel_request).selectable_departments(@current_user).sort_by(&:name)
  end

  private

    # Returns the per_page used in the pagniation. xlsx should have all
    # records, otherwise defaults to the WillPaginate global
    def per_page
      params[:format] == 'xlsx' ? -1 : WillPaginate.per_page
    end

    # Returns a send_data of the XLSX of a record set ( used in the request
    # controllers )
    #
    # records: the ransack results in the query
    # filename: the filename sent in the response headers
    def send_xlsx(records, filename = 'export')
      stream = render_to_string(template: 'shared/index', locals: { records: records })
      send_data(stream, filename: "#{filename}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.xlsx")
    end

    # Sets the default sort columns for request index pages
    # This modifies the ransack @q instance var
    def default_sorts!
      return false unless @q
      @q.sorts = %w( division_code department_code unit_code employee_type_code ) if @q.sorts.empty?
    end

    # sets the associations to be included in the result set
    #
    # assocs: an array of associations to be included in the query
    def include_associations!(assocs = [])
      return false unless @q
      @q.result.includes(assocs)
    end

    # scopes the ransack @q query according to the pundit policy and paginated
    #
    # params: indifferent hash that's just the controller params passed in
    def scope_records(params = {})
      policy_scope(@q.result.page(params[:page]).per_page(per_page)) || []
    end
end
