require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

# A patch to keep Cap setup/teardowns from locking the DB
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def run_as_user(user)
    user = user.cas_directory_id if user.is_a?(User)
    original_user = if session[:cas] && session[:cas][:user]
                      session[:cas][:user]
                    end
    session[:cas] = { user: user }
    begin
      yield user
    ensure
      session[:cas][:user] = original_user
    end
  end

  # this creates a temp user that is destroyed afterwards
  # pass in if it's an admin
  # and the roles by passing in an array of Organizations
  # and the block to yield to run_as_user
  def with_temp_user(admin: false, roles: [])
    user = User.create(cas_directory_id: SecureRandom.hex, name: SecureRandom.hex, admin: admin)
    roles.each { |role| user.roles.create(organization: role) }
    begin
      yield user
    ensure
      user.destroy!
    end
  end
end

# test/test_helper.rb:
require 'capybara/rails'
require 'capybara/minitest'
require 'capybara-screenshot/minitest'

Capybara.register_driver :chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[--window-size=1500,768] }
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome,
                                      desired_capabilities: caps)
end

Capybara.register_driver :headless_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1500,768] }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome,
                                      desired_capabilities: caps)
end

# just the selenium screenshot driver.
%i[chrome headless_chrome].each do |chrome_driver|
  Capybara::Screenshot.register_driver(chrome_driver) do |driver, path|
    driver.browser.save_screenshot(path)
  end
end

class JavaScriptError < StandardError; end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Capybara::Screenshot::MiniTestPlugin

  def use_chrome!
    Capybara.current_driver = ENV['SELENIUM_CHROME'] ? :chrome : :headless_chrome
  end

  def javascript_errors
    page.driver.browser.manage.logs.get(:browser)
        .select { |e| e.level == 'SEVERE' && e.message.present? }
        .collect(&:message)
  end

  def javascript_errors?
    errors = javascript_errors # if you get the log, you clear the log...
    raise JavaScriptError, errors.join("\n\n") if errors.present?
  end

  def teardown
    javascript_errors?
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def login(user)
    visit '/'
    fill_in 'username', with: user
    fill_in 'password', with: 'any password'
    click_button 'Login'
  end

  def login_admin
    login('admin')
  end

  def login_not_admin
    login('not_admin')
  end
end
