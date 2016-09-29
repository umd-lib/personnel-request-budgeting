require 'test_helper'

# Tests for AdminOnlyPolicy class
class ReportPolicyTest < ActiveSupport::TestCase
  def setup
    @admin_user = users(:test_admin)
  end

  def test_edit
    refute Pundit.policy!(@admin_user, Report).edit?
  end
end
