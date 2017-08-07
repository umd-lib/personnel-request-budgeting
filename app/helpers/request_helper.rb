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
  %w[ hourly_rate annual_base_pay annual_cost nonop_funds].each do |field|
    define_method "render_#{field}".intern do |record|
      number_to_currency record.send(field.intern)
    end
  end

  # Returns if we are in the arcihve mode
  def archive?
    params[:archive] == 'true'
  end
end
