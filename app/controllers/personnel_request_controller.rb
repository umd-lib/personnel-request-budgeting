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

    # Returns true/false if the user is looking at the archive
    def archive?
      ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:archived])
    end

    # takes a string of the model_name, checks if the record exist, then checks if it's archived before sending
    # RecordNotFound
    def find_active_or_archived(model_name)
      klass = model_name.constantize
      begin
        return klass.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        klass = "Archived#{model_name}".constantize
        return klass.find(params[:id])
      end
    end

    # Returns the per_page used in the pagniation. xlsx should have all
    # records, otherwise defaults to the WillPaginate global
    def per_page
      WillPaginate.per_page
    end

    # Returns a send_data of the XLSX of a record set ( used in the request
    # controllers )
    #
    # record_set: the ransack results in the query
    # filename: the filename sent in the response headers
    def send_xlsx(record_set, klass)
      stream = render_to_string(template: 'shared/index', locals: { klass: klass, record_set: [record_set] })
      send_data(stream, filename: "#{klass.to_s.underscore}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.xlsx")
    end

    # Sets the default sort columns for request index pages
    # This modifies the ransack @q instance var
    def default_sorts!
      return false unless @q
      @q.sorts = %w(division_code department_code unit_code employee_type_code) if @q.sorts.empty?
    end

    def assocs
      base_assocs = %i(division department employee_type request_type review_status unit)
      base_assocs << :employee_type if controller_name =~ /^ContractorRequest/
      base_assocs
    end

    # scopes the ransack @q query according to the pundit policy and paginated
    #
    # params: indifferent hash that's just the controller params passed in
    def scope_records(params = {})
      if params[:format] == 'xlsx'
        # xlsx format should not use pagination, and always return all records
        # allowed by scope
        policy_scope(@q.result.includes(assocs))
      else
        # Other formats use pagination
        policy_scope(@q.result.includes(assocs)
                     .page(params[:page]).per_page(per_page)) || []
      end
    end

    # called when there's a policy failure.
    # @param exception [Exception] the error that has been raise in validation
    def not_authorized(exception)
      # in edit and index situations just redirect to the root
      if exception.record.is_a?(Class) || !exception.record.new_record?
        deny_and_redirect generic_not_authorized_msg(exception)
      # if there's a specific record issue, let's handle that.
      else
        handle_record_not_authorized exception
      end
    end

    # Called when there's a policy error on a specific record
    # @param exception [Exception] the error that has been raise in validation
    def handle_record_not_authorized(exception)
      # if we are making a new record, lets just reshow the form to let folks
      # try and fix and resubmit
      variable = "@#{controller_name.singularize}".intern
      record = instance_variable_get(variable).dup
      case exception
      when Pundit::NotAuthorizedDepartmentError
        add_errors_and_render(variable, :department_id, "You are not allowed to make requests to department: #{record.department.name}")
      when Pundit::NotAuthorizedUnitError
        add_errors_and_render(variable, :unit_id, "You are not allowed to make requests to unit: #{record.unit.name}")
      when Pundit::NotAuthorizedError
        deny_and_redirect generic_not_authorized_msg(exception)
      end
    end

    # Provides a generic "Not Authorized" message for the given exception
    #
    # @param exception [Exception] the exception that was raised
    # @return [String] a generic "not authorized" message
    def generic_not_authorized_msg(exception)
      action = 'access'
      action = exception.query.chomp('?') if exception.query
      "You are not allowed to #{action} the requested record"
    end

    # This just flashes a message and redirects to the root url
    #
    # @param msg [String] A message to be displayed in the flash
    def deny_and_redirect(msg)
      flash[:error] = "Access Denied -- #{msg}"
      redirect_to root_url
    end

    # Add vailadation errors to the record and instructs users to try again
    #
    # @param variable [Symbol] The name of the instance variable the record is
    # stored in
    # @param field [Symbol] The name record field to add the error to
    # @param msg [String] A message to be displayed in the flash
    def add_errors_and_render(variable, field, msg)
      instance_variable_get(variable).errors.add(field, msg)
      assign_selectable_departments_and_units(instance_variable_get(variable))
      render :edit
    end
end
