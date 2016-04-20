# Test for clearing the "Subdepartment" dropdown field
module ClearSubdepartmentDropdownTest
  extend ActiveSupport::Concern

  included do
    test 'subdepartment should have clear option when subdepartment is selected' do
      assert_select 'select[id=?] option', "#{@field_prefix}_subdepartment_id" do |opts|
        assert_equal '<Clear Subdepartment>', opts[0].text
      end
    end
  end
end
