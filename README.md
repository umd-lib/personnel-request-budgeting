# annual-staffing-request

A Rails application for submitting staffing requests as part of the library budgeting process.

## Quick Start

Requires:

* Ruby 2.2.4
* Bundler

### Setup
1) Checkout the code and install the dependencies:

```
> git clone git@github.com:umd-lib/annual-staffing-request
> cd annual-staffing-request
> ./bin/bundle install --without production
```

2) Set up the database:

```
> ./bin/rake db:reset
```

3) (Optional) Populate database with sample data:

```
> ./bin/rake db:reset_with_sample_data
```

### Adding an Admin User and Roles

4) The application uses CAS authentication to only allow known users to log in. The seed data for the database does not contain any users. Run the following Rake task to add a user:

```
> ./bin/rake 'db:add_admin_cas_user[<CAS DIRECTORY ID>,<FULL NAME>]'
```
and replacing the "\<CAS DIRECTORY ID>" and "\<FULL NAME>" with valid user information. For example, to add "John Smith" with a CAS Directory ID of "jsmith":

```
> rake 'db:add_cas_user[jsmith, John Smith]'
```

### Run the web application

5) To run the web application:

```
> ./bin/rails s
```

## Production Environment Configuration

Requires:

* Postgres client to be installed (on RedHat, the "postgresql" and 
"postgresql-devel" packages)

The application uses the "dotenv" gem to configure the production environment.
The gem expects a ".env" file in the root directory to contain the environment
variables that are provided to Ruby. A sample "env_example" file has been
provided to assist with this process. Simply copy the "env_example" file to
".env" and fill out the parameters as appropriate.

The configured .env file should _not_ be checked into the Git repository, as it
contains credential information.

## Fiscal Year Rollover

** DANGER: BACKUP YOUR DATABASE BEFORE ATTEMPTING THIS **

The database is setup with an active table ("Requests") and table for archived
requests ("ArchivedRequests"). The archived requests are moved over during the
fiscal year rollover event. In regards to the application, this happens by
running a rake task that copies all the records in the Requests table into the
ArchivedRequests table, with a datestamp that indicates the fiscal year for the
transfered records. 

To do this, run the following command:
```
> ./bin/rake db:archive_current_records[2016]
```

Change the '2016' to match what fiscal year you are wanting to tag the records
with. 

This will empty all the records in the Requests table, so be sure to backup the
database in case you need to revert the process. 

### Running Test 

To run the test, you can use the standard rake command: 
```
> ./bin/rkae test
```

Or to use Guard:
```
> ./bin/bundle exec guard
```

Integration tests are run using Selenium and Chrome, which requires Chrome/Chromium browser
and  [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/downloads)
installed. By default, they are run in headless mode. You can run them in
regular mode by setting an environment variable to SELENIUM_CHROME: 
```
> export SELENIUM_CHROME=true
> ./bin/rake test:ingtegration
```

On failures, screenshots are saved in the tmp/capybara directory, but YMMV
depending on your version of Chrome.
