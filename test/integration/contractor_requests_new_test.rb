require 'test_helper'

# Integration test for the ContractorRequest new page
class ContractorRequestsNewTest < ActionDispatch::IntegrationTest
  def setup
  end

  test 'number_of_months field should default to 1' do
    get new_contractor_request_path
    doc = Nokogiri::HTML(response.body)
    num_months = doc.xpath("//input[@id='contractor_request_number_of_months']/@value").to_s.to_i
    assert_equal 1, num_months
  end
end
