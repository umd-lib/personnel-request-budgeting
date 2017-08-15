source 'https://rubygems.org'

# use HTTPS for github repos (see https://bundler.io/git.html#security)
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
gem 'sprockets-es6'

# Use sqlite3 as the database for Active Record
gem 'pg', group: :production
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# CAS authentication
gem 'pundit'
gem 'rack-cas'

# UMD Bootstrap style
gem 'umd_lib_style', github: 'umd-lib/umd_lib_style', ref: '0.2.0'

gem 'cocoon'
gem 'simple_form'

gem 'axlsx_rails'
gem 'fiscali'
gem 'money-rails', '~>1'
gem 'will_paginate'
gem 'will_paginate-bootstrap'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'bullet'
  gem 'byebug'
  gem 'faker'
  gem 'pry-rails'
  gem 'roo'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'guard', require: false
  gem 'guard-minitest', require: false
  gem 'rb-fsevent', require: false
  gem 'ruby_dep', '~> 1.3.1'
  gem 'terminal-notifier-guard', require: false
end

group :test do
  gem 'connection_pool'
  gem 'launchy'
  gem 'minitest-rails-capybara'
  gem 'minitest-reporters'
  # use the head to get the callback functionality
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'mocha'
  gem 'poltergeist'
  gem 'rack_session_access'
  gem 'shoulda-context'
  gem 'shoulda-matchers', '>= 3.0.1'
  gem 'test_after_commit'

  # Code analysis tools
  gem 'rubocop', require: false
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
end
