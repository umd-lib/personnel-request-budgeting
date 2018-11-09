# frozen_string_literal: true

require 'application_system_test_case'

class ReportIndexViewTest < ApplicationSystemTestCase
  def setup
    login_admin
  end

  test 'should keep page and sort when deleting' do
    click_link 'admin'
    click_link 'Reports'

    headers = all('th')
    headers.each do |header|
      header.find('a').click
    end
  end
end
