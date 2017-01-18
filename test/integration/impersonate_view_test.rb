require 'test_helper'

# Integration test for impersonation mode view
class ImpersonateViewTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user = users(:test_admin)
    @impersonated_user = users(:test_not_admin)
  end

  test 'extra padding class present in impersonation mode' do
    run_as_user(@admin_user) do
      get impersonate_user_path user_id: @impersonated_user
      get root_path
      doc = Nokogiri::HTML(response.body)
      classes = doc.xpath("//html/body/div").first['class']
      assert_equal 'container-fluid impersonate-extra-padding-top', classes
    end
  end

  test 'extra padding class absent in normal mode' do
    run_as_user(@admin_user) do
      get root_path
      doc = Nokogiri::HTML(response.body)
      classes = doc.xpath("//html/body/div").first['class']
      assert_equal 'container-fluid', classes
    end
  end

  def teardown
    # Restore normal "test_user"
    #delete '/impersonate/revert'
    delete revert_impersonate_user_path
  end
end
