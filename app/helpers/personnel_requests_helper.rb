module PersonnelRequestsHelper
  CURRENCY_FIELDS = %i(nonop_funds annual_cost annual_base_pay hourly_rate).freeze

  LENGTHY_FIELDS = %i(justification review_comment).freeze

  # Returns a list of fields for a record
  #
  # @param klass [Class] the active record klass being displayed
  # @param show_all [Boolean] option to include all fields in class
  # @return [Array] the list of fields being displayed
  def fields(klass, show_all = false)
    fields = send(:"#{klass.to_s.underscore}_fields") unless show_all
    fields = send(:"#{klass.to_s.underscore}_all_fields") if show_all
    fields
  end

  # Returns a list of the formats used for styling export outputs
  #
  # @param fields [Array] the fields to generate a list of formats
  # @return [Array] list of associated formats to the fields
  def field_formats(fields)
    fields.map { |field| currency_fields.include?(field) ? :currency : :default }
  end

  # Returns a list of the widths used for styling export outputs
  #
  # @param fields [Array] the fields to generate a list of formats
  # @return [Array] list of widths to the fields
  def field_widths(fields)
    fields.map { |field| lengthy_fields.include?(field) ? 30 : nil }
  end

  # Returns a list of fields for a record and a list of formats for those
  # fields
  #
  # @param klass [Class] the active record klass being displayed
  # @param show_all [Boolean] option to include all fields in class
  # @return [Array] the list of fields being displayed
  # @return [Array] the list of formats to be displayed
  def fields_and_formats_and_widths(klass, show_all = false)
    fields = fields(klass, show_all)
    formats = field_formats(fields)
    widths = field_widths(fields)
    [fields, formats, widths]
  end

  # Calls the field on the record and attempts to display it.
  # If there is special formatting on the field, define a "render_FIELD_NAME"
  # method that takes the record and tweaks the field
  #
  # @param record [ActiveRecord] the record with the field
  # @param field [Symbol] the field name ( use __ to indicate associations )
  # @param format [Symbol] any special format to call a specific render method
  # @return [String] value from record field
  def call_record_field(record, field, format = nil)
    method = "render_#{field}_#{format}".chomp('_').intern
    if respond_to? method
      send(method, record)
    else
      record.call_field(field)
    end
  end

  # Just return the currency fields
  def currency_fields
    CURRENCY_FIELDS
  end

  # Just return the lengthy fields
  def lengthy_fields
    LENGTHY_FIELDS
  end

  # these are the fields that we want to render into a currency
  # since we've added special xlsx formatting, we need to call a special helper
  # for the excel exports that is _xslx.
  CURRENCY_FIELDS.each do |m|
    define_method("render_#{m}".intern) { |r| number_to_currency r.call_field(m.intern) }
    define_method("render_#{m}_xlsx".intern) do |r|
      field = r.call_field(m.intern) || BigDecimal(0)
      format '%.2f', field.truncate(2)
    end
  end

  # Formats review status based on the codey
  # @param record [ActiveRecord] the record to be called
  def render_review_status__name(record)
    if record.review_status.code == 'UnderReview'
      ''
    else
      record.call_field(:review_status__name)
    end
  end

  # Returns an array of the fields used in labor_requests
  #
  # @return [Array] list of fields
  def labor_request_fields
    %i( position_title employee_type__code request_type__code contractor_name
        number_of_positions hourly_rate hours_per_week number_of_weeks annual_cost
        nonop_funds division__code department__code unit__code review_status__name)
  end

  # Returns an ordered array of all the fields used in labor_requests
  #
  # @return [Array] list of fields
  def labor_request_all_fields
    %i( position_title employee_type__code request_type__code contractor_name
        number_of_positions hourly_rate hours_per_week number_of_weeks annual_cost
        nonop_funds nonop_source division__code department__code unit__code justification
        review_status__name review_comment created_at updated_at )
  end

  # Returns an  array of the fields used in staff_requests
  #
  # @return [Array] list of fields
  def staff_request_fields
    %i( position_title employee_type__code request_type__code annual_base_pay
        nonop_funds division__code department__code unit__code review_status__name)
  end

  # Returns an ordered array of all the fields used in contractor_requests
  #
  # @return [Array] list of fields
  def staff_request_all_fields
    %i( position_title employee_type__code request_type__code annual_base_pay nonop_funds
        nonop_source division__code department__code unit__code justification review_status__name
        review_comment created_at updated_at)
  end

  # Returns an array of the fields used in contractor_requests
  #
  # @return [Array] list of fields
  def contractor_request_fields
    %i( position_title employee_type__code request_type__code contractor_name
        number_of_months annual_base_pay nonop_funds division__code department__code
        unit__code review_status__name )
  end

  # Returns an ordered array of all the fields used in contractor_requests
  #
  # @return [Array] list of fields
  def contractor_request_all_fields
    %i( position_title employee_type__code request_type__code contractor_name
        number_of_months annual_base_pay nonop_funds nonop_source division__code
        department__code unit__code justification review_status__name review_comment
        created_at updated_at)
  end
end
