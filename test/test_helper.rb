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
 
  def before_setup
    CounterCacheManager.run
    super
  end

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
