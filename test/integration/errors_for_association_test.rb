require 'test_helper'

# Integration test for validating the "errors_for_association" Rails patch.
# See config/initializers/errors_for_association.rb
class ErrorsForAssociationTest < ActionDispatch::IntegrationTest
  def setup
  end

  test 'unsuccessful create' do
    get new_contractor_request_path
    assert_no_difference 'ContractorRequest.count' do
      post contractor_requests_path, contractor_request: {
        employee_type_id: nil,
        position_description: nil,
        request_type_id: nil,
        contractor_name: nil,
        number_of_months: nil,
        annual_base_pay: nil,
        nonop_funds: nil,
        nonop_source: nil,
        department_id: nil,
        subdepartment_id: nil,
        justification: nil
      }
    end
    assert_template 'contractor_requests/new'

    # Verify that error is shown on "select" field (label and field)
    # with association
    assert_select 'div.field_with_errors' do
      required_select_fields = %w(employee_type_id request_type_id department_id)
      required_select_fields.each do |field|
        assert_select 'label[for=?]', "contractor_request_#{field}"
        assert_select '[id=?]', "contractor_request_#{field}"
      end
    end
  end

  test 'unsuccessful edit (employee type)' do
    contractor_request = contractor_requests(:c2)
    get edit_contractor_request_path(contractor_request)
    assert_template 'contractor_requests/edit'
    patch contractor_request_path(contractor_request), contractor_request: { employee_type_id: '' }
    assert_template 'contractor_requests/edit'

    # Verify that error is shown on "select" field (label and field)
    # with association
    assert_select 'div.field_with_errors' do
      assert_select 'label[for=?]', 'contractor_request_employee_type_id'
      assert_select '[id=?]', 'contractor_request_employee_type_id'
    end
  end
end
