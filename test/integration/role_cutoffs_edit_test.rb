require 'test_helper'

# Integration test for the RoleCutoff edit page
class RoleCutoffEditTest < ActionDispatch::IntegrationTest
  test 'list all button is available' do
    role_cutoff_to_edit = role_cutoffs(:one)

    get edit_role_cutoff_path(role_cutoff_to_edit)
    assert_select "[href='/role_cutoffs']"
  end

  test 'role type drop-down should not contain admin role' do
    role_cutoff_to_edit = role_cutoffs(:one)
    get edit_role_cutoff_path(role_cutoff_to_edit)

    admin_name = role_types(:admin).name.downcase
    options = css_select '#role_cutoff_role_type_id>option'
    options.each do |option|
      assert option.text.downcase != admin_name
    end
  end
end
