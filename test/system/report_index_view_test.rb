# frozen_string_literal: true

require 'application_system_test_case'

class ReportIndexViewTest < ApplicationSystemTestCase
  def setup
    login_admin
  end

  test 'should keep page and sort when deleting' do
    click_link 'admin'
    click_link 'Reports'
    click_link 'Name'
    click_link 'Format'
    click_link 'Creator'
    click_link 'Created At'
    assert :success
  end
end
