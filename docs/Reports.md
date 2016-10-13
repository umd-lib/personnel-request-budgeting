<!--
 @title Reports 
-->

# Reports

There are a few parts to be aware of when making reports:

* Report - the ActiveRecord for requesting and saving requested reports.
* Report::Manager - used to register available reports
* ReportJob - the ActiveJob class used to run the requested reports
* Reportable - the mixin that creates a specific report
* the Reportable report - the class that holds your query and formatting
  options. (See app/models/reports/requests_by_type_report.rb for an example).
* the reports form partial - the request UI for a report. Uses app/views/reports/_report_form partial by default.

To make a new report, first you'll need to define your report class. This
looks like this:

```ruby
# Sample report
class MyReport
  include Reportable

  class << self
    # @return [String] human-readable description of the report, displayed in
    #   the GUI.
    def description
      'List all Staff Requests for a given department.'
    end

    # This method is only needed if user-provided parameters are used.
    # @return [Array<Symbol>] the parameters allowed for user input
    def allowed_parameters
      %i( department_id )
    end

    # Define the output formats here. Typically, this will be 'xlsx' for
    # an Excel spreadsheet.
    #
    # @return [Array<String, Symbol>] the output formats this report is
    #   available in.
    def formats
      %w( xlsx )
    end

    # Used by the template to define worksheet names. This method is
    # template-specific, and so may not be needed by all templates.
    # @return [Array<String>] the worksheet names
    def worksheets
      %w( StaffRequest )
    end

    # @return [String] the view template to use in formatting the report output
    def template
      'shared/index'
    end
  end

  # Define the report query here. The actual object returned can
  # be anything, as long as it is consistent with what the template
  # is expecting.
  #
  # For example, the returned object may be a simple Array or Hash,
  # or something more sophisticated such as an ActiveRecord or Enumerator.
  #
  # For DB queries, it is best to do something that calls the db while its
  # being iterated, to avoid making a large db query and keeping it in
  # memory (e.g. avoid using .all or loading a bunch of records into an array)
  #
  # User-specified parameters, if applicable, can be retrieved using the
  # "parameters" accessor.
  #
  # @return [Object] the data used by the template
  def query
    # The following returns an array containing an Enumerator, using the
    # department id from the "parameters" accessor to limit the results to
    # requests in that department.
    [StaffRequest.where(department_id: parameters[:department_id]).find_each]
  end
end
```

The report class should be saved in the apps/models/reports/ directory, and the file name should end with "\_report.rb" (i.e., "my_report.rb" for the sample above). This enables the Report::Manager class to find the report and make it available on the /reports/new page.

Note: When a new report is created, it may be necessary to restart the Rails server, so that Report::Manager will load the new report.

## Report Output Templates

A report can specify the template to use for output using the "template" method, which returns a String indicating the location of the template. The format of the report determines the template's extension. For example, for the sample report above, the actual template file being used is "shared/index.xlsx.axlsx" because the report format is "xlsx" format. The default if no "template" method is provided is ""shared/index" (see app/views/shared/index.xlsx.axlsx).

The template is passed the return value from the "query" method of the report. This return value can be any object -- the report and template just need to be consistent.

## Reports with Parameters

By default, a report will use the app/views/reports/_report_form.html.erb partial, which does not provide for user input. If user input is needed to define parameters for the query, create a new partial based on the name of your report in snake_case.

User-provided parameters are passed to the Report model "parameters" attribute.
This is a serialized attribute, so you can pass in a Ruby object (Hash,
Array, etc.) that is marshalled when the ActiveRecord Report object is made. This
parameter object is passed into the Reportable object and can be used in the
query (as in the "query" method in the sample report above).

For example, the above sample report uses a user-provided "department" parameter to determine the requests to return. The following partial would be placed in the app/views/reports/ directory, and named "_my_report_form.html.erb":

```erb
<%= form_for @report,  namespace: "#{subreport.class.to_s.underscore}_" do |f| %>
  <%= render 'shared/form_errors', errors: @report.errors %>
  <div class "panel-heading"><h3 class="panel-title"><%= report_name %> : <%= subreport.description %></h3></div> 
  <table class="table table-striped">
    <tbody>
      <tr>
        <th><%= f.label :format %></th>
        <td><%= f.select :format, report_formats(subreport) %></td>
      </tr>
      <%= f.fields_for :parameters do |pf| %> 
        <tr>
          <th><%= pf.label :department %></th>
          <td><%= pf.select :department_id,  Department.all.collect { |d| [ d.name, d.id ] } %></td>
        </tr>
      <% end %>   
    </tbody>
  </table>

  <%= f.hidden_field :user_id, value:  current_user.id %>
  <%= f.hidden_field :name, value: subreport.class.to_s %>
 
  <%= render partial: 'shared/form_action_buttons', locals: { form: f, object: @report } %>

<% end %>
```

This will add something like: report[:parameters] = { department_id: 19 }
to your Report object when saving in the Report#new action. See app/views/reports/_requests_by_department_report_form.html.erb for a similar example.
