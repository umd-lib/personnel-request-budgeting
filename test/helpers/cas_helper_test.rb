require 'test_helper'

class CasHelperTest < ActionView::TestCase
  include CasHelper

  def setup
    @admin_user = users(:test_admin)
    @impersonated_user = users(:one)

    # Set admin_user as the current user
    session[:cas_user] = @admin_user.cas_directory_id
  end

  def test_current_user
    assert_equal @admin_user, current_user
    refute impersonating_user?
    assert_equal @admin_user, actual_user
  end

  def test_current_user_when_impersonating
    assert_equal @admin_user, current_user

    session[ImpersonateController::IMPERSONATE_USER_PARAM] = @impersonated_user.id

    assert impersonating_user?

    # Verify current_user, impersonated_user, actual_user
    assert_equal @impersonated_user, current_user
    assert_equal @impersonated_user, impersonated_user
    assert_equal @admin_user, actual_user
  end
end
