require 'test_helper'

# Integration test for the LaborRequest new page
class LaborRequestsNewTest < ActionDispatch::IntegrationTest
  def setup
  end

  test 'number_of_positions field should default to 1' do
    get new_labor_request_path
    doc = Nokogiri::HTML(response.body)
    num_positions = doc.xpath("//input[@id='labor_request_number_of_positions']/@value").to_s.to_i
    assert_equal 1, num_positions
  end

  test 'number_of_week field should default to 1' do
    get new_labor_request_path
    doc = Nokogiri::HTML(response.body)
    num_weeks = doc.xpath("//input[@id='labor_request_number_of_weeks']/@value").to_s.to_i
    assert_equal 1, num_weeks
  end
end
