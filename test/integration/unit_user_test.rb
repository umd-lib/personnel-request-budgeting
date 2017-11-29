require 'test_helper'

class UnitUserTest < ActionDispatch::IntegrationTest
  def setup
    use_chrome!
    login_not_admin

    @user = users(:not_admin)
    @unit = @user.organizations.find(&:unit?)
  end

  test 'should require a unit if the user is a unit user' do
    click_link 'Labor and Assistance'
    click_link 'New'

    select 'Faculty', from: 'Employee type'
    select 'New', from: 'Request type'
    fill_in 'Contractor name', with: SecureRandom.hex
    fill_in 'Number of positions', with: 1
    fill_in 'Hours per week', with: '9.99'
    fill_in 'Hourly rate', with: '9.99'
    fill_in 'Number of weeks', with: '9'
    select @unit.parent.name, from: 'Department'
    fill_in 'Justification', with: 'This is a test'
    fill_in 'Position title', with: SecureRandom.hex
    find('.page-header .btn-success').click

    refute page.has_content?('Labor and Assistance Requests successfully created.')
    assert page.has_content?('Unit is required for users with only Unit permissions')

    select @unit.name, from: 'Unit'
    find('.page-footer .btn-success').click

    assert page.has_content?('Labor and Assistance Requests successfully created.')
    refute page.has_content?('Unit is required for users with only Unit permissions')
  end
end
