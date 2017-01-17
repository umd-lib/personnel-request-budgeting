require 'test_helper'
require 'ostruct'

class PersonnelRequestsHelperTest < ActionView::TestCase
  include PersonnelRequestsHelper

  def setup
  end

  def test_report_formats
    record = contractor_requests(:cont_fac_renewal)
    assert_equal '', render_review_status__name(record)
    record.review_status.code = 'Boom'
    record.review_status.name = 'BOOM!'
    assert_equal 'BOOM!', render_review_status__name(record)
  end

  def test_currency_formats
    fields = %w( nonop_funds  annual_cost  annual_base_pay  hourly_rate  )

    # this abstracts out the ActiveModel class being used
    proxy = OpenStruct.new
    proxy.define_singleton_method(:call_field) { |field| send(field) }

    fields.each do |m|
      val = rand(10_000)
      proxy.send("#{m}=".intern, val)
      assert_equal number_to_currency(val), call_record_field(proxy, m)
    end
  end

  def test_field_widths_lengthy_fields
    fields = %i( justification review_comment )
    widths = field_widths(fields)

    assert_equal fields.length, widths.length

    widths.each do |width|
      assert width.is_a? Integer
    end
  end

  def test_field_widths_not_lengthy_fields
    fields = %i( position_title employee_type request_type annual_base_pay )
    widths = field_widths(fields)

    assert_equal fields.length, widths.length

    widths.each do |width|
      assert_nil width
    end
  end
end
