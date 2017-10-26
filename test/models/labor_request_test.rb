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

  test 'justifcation length should be less than 125 words (unless its archived)' do
    assert @request.valid?
    @request.justification = ' word ' * 126
    refute @request.valid?

    archived = ArchivedLaborRequest.first
    assert archived.valid?
    archived.justification = ' word ' * 126
    assert archived.valid?
  end
end
