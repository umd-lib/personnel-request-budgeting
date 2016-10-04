require 'test_helper'
require 'ostruct'

class PersonnelRequestsHelperTest < ActionView::TestCase
  include PersonnelRequestsHelper
  
  def setup
  end

  def test_report_formats
    record = contractor_requests(:cont_fac_renewal)
    assert_equal "", render_review_status__name(record)
    record.review_status.code = "Boom"
    record.review_status.name = "BOOM!"
    assert_equal "BOOM!", render_review_status__name(record)
  end

  def test_currency_formats
    fields = %w( nonop_funds  annual_cost  annual_base_pay  hourly_rate  )
   
    # this abstracts out the AM class being used
    thingy = OpenStruct.new
    thingy.define_singleton_method(:call_field) { |field| self.send(field) } 
    
    fields.each do |m|
      val = rand(10000) 
      thingy.send("#{m}=".intern, val) 
      assert_equal  number_to_currency( val ), call_record_field( thingy , m )
    end
  end

end
