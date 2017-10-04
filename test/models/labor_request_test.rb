require 'test_helper'

# Tests for the "User" model
class LaborRequestTest < ActiveSupport::TestCase
  def setup
    @request = LaborRequest.where('unit_id IS NOT NULL').first
  end

  test 'unit should be in the department' do
    assert @request.valid?
    @request.unit = Organization.where('organization_id IS NOT ?', @request.organization.id)
                                .where(organization_type: Organization.organization_types['unit']).first
    refute @request.valid?
  end
end
