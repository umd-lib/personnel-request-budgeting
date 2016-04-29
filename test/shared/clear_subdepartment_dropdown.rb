# Test for clearing the "Unit" dropdown field
module ClearUnitDropdownTest
  extend ActiveSupport::Concern

  included do
    test 'unit should have clear option when unit is selected' do
      assert_select 'select[id=?] option', "#{@field_prefix}_unit_id" do |opts|
        assert_equal '<Clear Unit>', opts[0].text
      end
    end
  end
end
