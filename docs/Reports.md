<!--
 @title Reports 
-->

# Reports

There are a few parts to be aware of when making reports:

* Report --  The ActiveRecord for requesting and saving requested reports.
* Report::Manager --  A simply utility used to register available reports
* ReportJob -- The ActiveJob class used to run the requested reports
* Reportable -- The mixin that creates a specific report
* the Reportable report -- the class that holds your query and formatting
  options.  ( See RequestsByTypeReport for an example ).
* the reports form partial - the request UI for a report.  uses _report_form partial by default.

To make a new report, first you'll need to define your report class. This
looks like this:

```ruby
  class MyReport
    
    include Reportable
    
    class << self

      # A basic description for UI
      def description
        'This is a really fun report that does great stuff'
      end


      # Define any output format here. Current XLSX is the only option. If you
      # want to add another, you'll need to add a view and adjust the {ReportJob}
      def formats
        %w( xlsx )
      end

       Add the names for your worksheet
      def worksheets
        %w( StaffRequests )
      end
  
    end

    # You define your report's query here. You use an array that is used in
    # each of the worksheets that are defined below. You can use just about
    # anything as long as it's an ActiveRecord ( or Enumerable ) -like obj ( i.e.
    # can be iterated on ).
    # For DB queries, its best to do something that calls the db while its
    # being iterated, to avoid making a large db q and keeping it in memory. (
    # e.g. avoid using .all or loading a bunch of records into an array )
    def query
      [StaffRequest.where(department_id: self.parameters[:department_id]).find_each]
    end

  end
```

By making this class, your report should be registered and available on the
/reports/new page. By default, it uses the _report_form.erb.html partial,
which only provides options to run a canned query. If you need something more
customized ( like adding parameters ), create a new partial based on the name
of your report in snakecase.

To pass parameters to a report, use the Report model parameters attribute.
This is a serialized attribute, so you can pass in a Ruby object ( Hash,
Array, etc. ) that marshalled when the ActiveRecord Record obj is made. This
parameter object is passed into the Reportable object and can be used in the
query ( see the query above ).

To add this to a view, you can use the following in your customized
reportable specific form partial:

```erb
<%= f.fields_for :parameters do |pf| %>
<tr>
  <th><%= pf.label :department %></th>
  <td><%= pf.select :department_id,  Department.all.collect { |d| [ d.name, d.id ] } %></td>
</tr>
<% end %>
```
This will add something like: report[:parameters] = { department_id: 19 }
to your Report object when saving in the report#new action.
