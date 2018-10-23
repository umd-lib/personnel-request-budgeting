# frozen_string_literal: true

require 'test_helper'

class IndexViewTest < ActionDispatch::IntegrationTest
  def setup
    use_chrome!
    login_admin
  end

  test 'should keep page and sort when deleting' do
    click_link 'Labor and Assistance'
    click_link '3'
    click_link 'Submitted By'
    url = current_url

    row = all('tr').last
    name = row.find('td[headers="position_title"]').text
    accept_alert do
      row.find('a.delete').click
    end

    assert current_url == url
    assert page.has_content? name
    refute find('table').text.include? name
  end
end
