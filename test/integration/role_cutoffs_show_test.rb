require 'test_helper'

# Integration test for the RoleCutoff show page
class RoleCutoffShowTest < ActionDispatch::IntegrationTest
  test 'list all button is available' do
    role_cutoff_to_edit = role_cutoffs(:one)

    get role_cutoff_path(role_cutoff_to_edit)
    assert_select "[href='/role_cutoffs']"
  end
end
