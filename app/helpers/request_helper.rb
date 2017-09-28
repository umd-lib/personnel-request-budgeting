module RequestHelper
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

  # helpers to display currency fields
  %w[hourly_rate annual_base_pay annual_cost nonop_funds].each do |field|
    define_method "render_#{field}".intern do |record|
      number_to_currency record.send(field.intern)
    end
    define_method("render_#{field}_xlsx".intern) do |record|
      money = record.call_field(field.intern) || BigDecimal(0)
      humanized_money money
    end
  end

  # Formats review status based on the code
  # @param record [ActiveRecord] the record to be called
  def render_review_status__name(record)
    record.review_status.name == 'Under Review' ? '' : record.review_status.name
  end

  # Returns if we are in the arcihve mode
  def archive?
    params[:archive] == 'true' || params[:archive] == true
  end

  def reset_sorts_link
    if @model_klass.name == 'Request'
      link_to(t('reset_sorting'), '/', class: 'btn btn-link')
    elsif sorted?
      link_to(t('reset_sorting'), polymorphic_path(@model_klass.source_class,
                                                   archive: params[:archive]), class: 'btn btn-link')
    end
  end

  # Report helper methods
  CURRENCY_FIELDS = %i[nonop_funds_cents annual_cost annual_base_pay_cents hourly_rate_cents].freeze

  LENGTHY_FIELDS = %i[justification review_comment].freeze

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
      humanized_money field
    end
  end

  # Returns an array of the fields used in labor_requests
  #
  # @return [Array] list of fields
  def labor_request_fields
    labor_request_all_fields - %i[nonop_source justification review_comment created_at updated_at]
  end

  # Returns an ordered array of all the fields used in labor_requests
  #
  # @return [Array] list of fields
  def labor_request_all_fields
    LaborRequest.fields
  end

  # Returns an  array of the fields used in staff_requests
  #
  # @return [Array] list of fields
  def staff_request_fields
    staff_request_all_fields - %i[nonop_source justification review_comment created_at updated_at]
  end

  # Returns an ordered array of all the fields used in contractor_requests
  #
  # @return [Array] list of fields
  def staff_request_all_fields
    StaffRequest.fields
  end

  # Returns an array of the fields used in contractor_requests
  #
  # @return [Array] list of fields
  def contractor_request_fields
    contractor_request_all_fields - %i[nonop_source justification review_comment created_at updated_at]
  end

  # Returns an ordered array of all the fields used in contractor_requests
  #
  # @return [Array] list of fields
  def contractor_request_all_fields
    ContractorRequest.fields
  end
end
