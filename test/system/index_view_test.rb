# frozen_string_literal: true

require 'application_system_test_case'

class IndexViewTest < ApplicationSystemTestCase
  def setup
    login_admin
  end

  test 'should keep page and sort when deleting' do
    click_link 'Labor and Assistance'
    click_link '2'
    click_link 'Submitted By'
    url = current_url

    row = all('tr').last
    name = row.find('td[headers="position_title"]').text
    accept_alert do
      row.find('a.delete').click
    end

    assert current_url == url
    assert page.has_content? name
    assert_not find('table').text.include? name
  end

  test 'should keep to in archive when sorting' do
    click_link 'Labor and Assistance'
    click_link 'View Archive'
    click_link 'Submitted By'
    assert page.has_content? 'View Active'
    assert page.has_content? 'You are currently in the archive'
  end
end
