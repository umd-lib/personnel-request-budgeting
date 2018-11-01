# frozen_string_literal: true

require 'test_helper'
require 'action_pack'

require 'fileutils'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  #  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  DOWNLOAD_DIR = File.join(Dir.tmpdir, 'downloads')

  def self.profile
    profile = Selenium::WebDriver::Chrome::Profile.new
    profile['download.default_directory'] = DOWNLOAD_DIR
    profile
  end

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: { profile: profile }

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
  end
end

class JavaScriptError < StandardError; end
