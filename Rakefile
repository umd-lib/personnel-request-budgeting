# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'rake/clean'

# See http://stackoverflow.com/a/27304470
# CLEAN is for intermediate files
CLEAN.include '.yardoc'
CLEAN.include 'test/reports'

# CLOBBER is for final products
CLOBBER.include 'coverage'
if Rails.env == 'development'
  CLOBBER.include 'db/development.sqlite3'
  CLOBBER.include 'db/development.sqlite3-journal'
  CLOBBER.include 'db/test.sqlite3'
  CLOBBER.include 'db/test.sqlite3-journal'
  CLOBBER.include 'doc'
  CLOBBER.include 'log/development.log'
  CLOBBER.include 'log/test.log'
  CLOBBER.include 'tmp'
end
