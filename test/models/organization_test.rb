require 'test_helper'

# Tests for the "Organization" model
class OrganizationTest < ActiveSupport::TestCase
  
  def setup
    @division = Organization.find_by(organization_type: Organization.organization_types["division"])
    @department = Organization.find_by(organization_type: Organization.organization_types["department"])
    @unit = Organization.find_by(organization_type: Organization.organization_types["unit"])
  end

  test 'should be valid' do
    assert @unit.valid?
  end

  test 'code should be present' do
    @unit.code = '  '
    assert_not @unit.valid?
  end


  test 'name should be present' do
    @unit.name = '  '
    assert_not @unit.valid?
  end

  test 'department should be present' do
    @unit.organization_id = nil
    assert_not @unit.valid?
  end

  test 'unit without associated records can be deleted' do
    unit = Organization.create( organization_type: Organization.organization_types["unit"], 
                               code: 'Delete', name: 'DeleteMe', parent: @unit.parent )
    assert_nothing_raised ActiveRecord::DeleteRestrictionError do
      unit.destroy
    end
  end

  test 'unit with associated records cannot be deleted' do
    staff_request = StaffRequest.first
    staff_request.organization = @unit.parent
    staff_request.unit = @unit
    staff_request.save!
    @unit.reload
    assert_not  @unit.destroy
  end
  
  test 'nor can unit with associated records be have valiues edited' do
    staff_request = StaffRequest.first
    staff_request.organization = @unit.parent
    staff_request.unit = @unit
    staff_request.save!
    %i[ name= code=  ].each do |key|
      @unit.send(key, SecureRandom.hex ) 
      assert_not  @unit.valid?
      @unit.reload
    end
    @unit.reload   
    assert  @unit.valid?
  end

  test 'there can only be one root' do
    unit = Organization.create( organization_type: Organization.organization_types["root"], 
                               code: 'Delete', name: 'DeleteMe', parent: @unit.parent )

    assert_not unit.valid?
    unit.organization_type = "unit"
    assert unit.valid?
  end

  test "it can provide grandchildren and greatgrandchildren" do
    root = Organization.find_by( organization_type: Organization.organization_types["root"] )
    assert_includes( root.children, @division )
    assert_not_includes( root.children, @department ) 
    assert_not_includes( root.children, @unit ) 
    
    assert_includes( root.grandchildren, @department )
    assert_not_includes( root.grandchildren, @unit ) 


    assert_includes( root.great_grandchildren, @unit )
  end


end
