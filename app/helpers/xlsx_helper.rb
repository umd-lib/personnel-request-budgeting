module XlsxHelper
  CURRENCY_FIELDS = %i[nonop_funds annual_cost annual_base_pay hourly_rate].freeze
  LENGTHY_FIELDS = %i[justification review_comment].freeze

  def field_widths(fields)
    fields.map { |field| LENGTHY_FIELDS.include?(field) ? 30 : nil }
  end

  def field_formats(fields)
    fields.map { |field| CURRENCY_FIELDS.include?(field) ? 30 : nil }
  end

  def formats_and_widths(fields)
    [field_widths(fields), field_formats(fields)]
  end

  def currency_field?(field)
    CURRENCY_FIELDS.include? field
  end
end
