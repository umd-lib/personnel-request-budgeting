require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start "rails"

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def run_as_user(user)
    user = user.cas_directory_id if user.is_a?(User) 
    original_user = if ( session[:cas] && session[:cas][:user] )
                      session[:cas][:user]
                    else
                      nil
                    end
    session[:cas] = { user: user }
    begin 
      yield
    ensure
      session[:cas][:user] = original_user
    end
  end

  # this creates a temp user that is destroyed afterwards
  # pass in if it's an admin
  # and the roles by passing in an array of Organizations
  # and the block to yield to run_as_user
  def with_temp_user(admin: false, roles: [] )
    user = User.create(cas_directory_id: SecureRandom.hex, name: SecureRandom.hex, admin: admin) 
    roles.each { |role| user.roles.create( organization: role ) }
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
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu ] } 
  ) 
 
  Capybara::Selenium::Driver.new(app, browser: :chrome,
                                desired_capabilities: caps )
end

# just the selenium screenshot driver.
%i[ chrome headless_chrome ].each do |chrome_driver|
  Capybara::Screenshot.register_driver(chrome_driver) do |driver, path|
    driver.browser.save_screenshot(path) 
  end
end



class ActionDispatch::IntegrationTest
 
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Capybara::Screenshot::MiniTestPlugin 

  def use_chrome!
    Capybara.current_driver = ENV["SELENIUM_CHROME"] ? :chrome : :headless_chrome
    Capybara.page.driver.browser.manage.window.resize_to 1500, 800
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def login_admin
    visit "/"
    fill_in 'username', with: 'admin'
    fill_in 'password', with: 'any password'
    click_button 'Login'
  end


end
