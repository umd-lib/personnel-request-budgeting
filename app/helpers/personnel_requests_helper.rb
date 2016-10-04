module PersonnelRequestsHelper
  
  # Returns a list of fields for a record
  #
  # @param klass [Class] the active record klass being displayed
  # @return [Array] the list of fields being displayed
  def fields(klass)
    send(:"#{klass.to_s.underscore}_fields")
  end

  # Calls the field on the record and attempts to display it.
  # If there is special formatting on the field, define a "render_FIELD_NAME"
  # method that takes the record and tweaks the field
  #
  # @param record [ActiveRecord] the record with the field
  # @param field [Symbol] the field name ( use __ to indicate associations )
  # @return [String] value from record field 
  def call_record_field(record, field)
    method = "render_#{field}".intern
    if respond_to? method
      send(method, record)
    else
      record.call_field(field)
    end
  end

  # these are the fields that we want to render into a currency
  %w( nonop_funds annual_cost annual_base_pay hourly_rate  ).each do |m|
    define_method("render_#{m}".intern) { |r| number_to_currency r.call_field(m.intern) }
  end

  # Formats review status based on the codey
  # @param record [ActiveRecord] the record to be called
  def render_review_status__name(record)
    if record.review_status.code == "UnderReview"
      ""
    else
      record.call_field(:review_status__name)
    end
  end

  # Returns an array of the fields used in labor_requests
  #
  # @return [Array] list of fields
  def labor_request_fields
    %i( position_description employee_type__code request_type__code contractor_name
        number_of_positions hourly_rate hours_per_week number_of_weeks annual_cost
        nonop_funds division__code department__code unit__code review_status__name
      )
  end
  
  # Returns an array of the fields used in staff_requests
  #
  # @return [Array] list of fields
  def staff_request_fields
    %i( position_description employee_type__code request_type__code annual_base_pay
        nonop_funds division__code department__code unit__code review_status__name
      )
  end
  
  # Returns an array of the fields used in contractor_requests
  #
  # @return [Array] list of fields
  def contractor_request_fields
    %i( position_description employee_type__code request_type__code contractor_name
        number_of_months annual_base_pay nonop_funds division__code department__code
        unit__code review_status__name )
  end
end
