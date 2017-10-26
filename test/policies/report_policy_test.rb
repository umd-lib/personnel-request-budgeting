require 'test_helper'

# Tests for ReportPolicy class
class ReportPolicyTest < ActiveSupport::TestCase
  def setup
    @admin_user = users(:admin)
  end

  def test_edit
    refute Pundit.policy!(@admin_user, Report).edit?
  end
end
