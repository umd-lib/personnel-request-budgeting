require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'roo'
require 'axlsx_rails'
require 'tempfile'

Dir[Rails.root.join('test/shared/**/*')].each { |f| require f }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Default user for testing has Admin privileges
  DEFAULT_TEST_USER = 'test_admin'.freeze
  CASClient::Frameworks::Rails::Filter.fake(DEFAULT_TEST_USER)

  # Runs the contents of a block using the given user as the current_user.
  # rubocop:disable Lint/RescueException
  def run_as_user(user)
    CASClient::Frameworks::Rails::Filter.fake(user.cas_directory_id)

    begin

      yield

    rescue Exception => e
      raise e
    ensure
      # Restore fake user
      CASClient::Frameworks::Rails::Filter.fake(ActiveSupport::TestCase::DEFAULT_TEST_USER)
    end
  end

  # Returns an array of divisions that have at least one record
  def divisions_with_records
    LaborRequest.select(:department_id).distinct.collect { |r| r.department.division }.uniq
  end

  # Returns an array of departments that have at least one record
  def departments_with_records
    LaborRequest.select(:department_id).distinct.collect(&:department)
  end

  # Returns an array of units that have at least one record
  def units_with_records
    LaborRequest.select(:unit_id).distinct.collect { |r| r.unit unless r.unit.nil? }.compact
  end

  # Verifies that the given field text only display two digits after the
  # decimal point.
  #
  # field: A description of the field to include in the error description
  # text: The text to check for correct currency formatting
  # optional_fields: Array of fields in currency_fields that are allowed to be
  #
  def verify_two_digit_currency_field(field, text)
    assert_match(/\d\.\d\d$/, text, "#{field} should have two decimal places")
  end

  # Creates a temporary user using the given roles, and then yields to a
  # provided block.
  #
  # admin: true if the user should be an admin, false otherwise.
  # divisions: An array of division codes the user should have a role for.
  # departments: An array of department codes the user should have a role for.
  # units: An array of unit codes the user should have a role for.
  #
  # Sample usage:
  #
  # a) User with "Admin" role:
  #
  #     run_as_temp_user(admin: true) do |temp_user|
  #       (block can access user as "temp_user")
  #     end
  #
  # b) User with "SSDR" department role:
  #
  #     run_as_temp_user(departments: ['SSDR']) do |temp_user|
  #       (block can access user as "temp_user")
  #     end
  #
  # b) User with "SSDR" department role and "LN" unit role:
  #
  #     run_as_temp_user(departments: ['SSDR'], units: ['LN']) do |temp_user|
  #       (block can access user as "temp_user")
  #     end
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def with_temp_user(admin: false, divisions: [], departments: [], units: [])
    temp_user = User.create(cas_directory_id: 'temp', name: 'Temp User')

    if admin
      Role.create!(user: temp_user, role_type: RoleType.find_by_code('admin'))
    end

    divisions.each do |division|
      Role.create!(user: temp_user, role_type: RoleType.find_by_code('division'),
                   division: Division.find_by_code(division))
    end

    departments.each do |department|
      Role.create!(user: temp_user, role_type: RoleType.find_by_code('department'),
                   department: Department.find_by_code(department))
    end

    units.each do |unit|
      Role.create!(user: temp_user, role_type: RoleType.find_by_code('unit'),
                   unit: Unit.find_by_code(unit))
    end

    yield temp_user

    Role.destroy_all(user: temp_user)
    temp_user.destroy!
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
